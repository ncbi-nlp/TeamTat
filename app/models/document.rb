class Document < ApplicationRecord
  belongs_to :project, counter_cache: true
  has_many :annotations, dependent: :destroy
  has_many :nodes, dependent: :destroy
  has_many :relations, -> { order 'sig2 asc' }, dependent: :destroy
  has_many :assigns, dependent: :destroy
  has_many :audits,-> { order 'created_at desc' }, dependent: :destroy
  serialize :infons

  def create_audit(user, message, request = "", result = "")
    if self.project.enable_audit
      self.audits.create!({
        user: user, project: self.project, 
        message: message,
        request: request, 
        result: result
      })
    end
  end

  def user_assign(user)
    self.assigns.where('user_id = ?', user.id).first
  end

  def done?(user)
    assign = self.user_assign(user)
    return assign.present? && assign.done
  end

  def curatable?(user)
    assign = self.user_assign(user)
    return assign.present? && assign.curatable
  end

  def curatable_value
    return "no" if self.assigns.blank?
    no_yes = self.assigns.where('curatable=1').count
    no_no = self.assigns.where('curatable=0').count
    return "yes" if self.assigns.size == no_yes
    return "no" if self.assigns.size == no_no
    return "undecided"
  end

  def assigns_done_count
    return self.assigns.where('done=true').count
  end

  def assigns_curatable_count
    return self.assigns.where('curatable=true').count
  end

  def update_done_count
    self.done_count = self.assigns.where('done=true').count
    self.save
  end
  
  def update_curatable_count
    self.curatable_count = self.assigns.where('curatable=true').count
    self.save
  end
  
  def curatable_str(user)
    if self.curatable?(user)
      "Y"
    else
      "N"
    end
  end

  def determined?
    self.annotations.where('version = ? and review_result = 0', self.version).empty?
  end

  def writable?(user, version)
    return "Project is finalized" if self.project.finalized
    return "Project is locked" if self.project.locked
    return "Processing a AI task" if self.project.in_task?
    return "Only the last version can be editable" if self.version != version
    return "" if self.project.manager?(user)
    return "Annotation round is not yet started" unless self.project.round_begin?
    return "Document is marked as done" if self.done?(user)
    return ""
  end

  def busy?(user)
    !self.project.round_begin? || self.done?(user) 
  end

  def image_url(filename) 
    "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC#{self.did}/bin/#{filename}" 
  end
  
  def save_document(d, bioc, project)
    self.did = d.id
    self.did_no = self.did.to_i
    self.project_id = project.id
    self.title = get_first_text_from_bioc(d)
    self.key = bioc.key
    builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
      xml.doc.create_internal_subset( 'collection', nil, 'BioC.dtd' )
      xml.collection {
        xml.source bioc.source
        xml.date bioc.date
        xml.key bioc.key
        BioCWriter::write_infon(xml, bioc)
        BioCWriter::write_document(xml, d)
      }
    end
    self.xml = builder.to_xml({save_with: 1})
    self.title = self.title.truncate(600) if self.title.size > 600
    self.title = self.title.force_encoding('UTF-8') 
    self.save
    self.handle_update_xml(d)
    self.detach_annotations_relations
  end

  def generate_bioc_annotation_node(node, annotation)
    a = SimpleBioC::Annotation.new(node)
    a.id = annotation.a_id
    a.text = annotation.content
    a.infons = annotation.infons
    a.infons["type"] = annotation.a_type
    a.infons["identifier"] = annotation.concept
    a.infons["note"] = annotation.note if annotation.note.present?
    a.infons["annotator"] = annotation.annotator if annotation.annotator.present?
    a.infons["updated_at"] = annotation.updated_at.utc.iso8601
    l = SimpleBioC::Location.new(a)
    l.offset = annotation.offset
    l.length = annotation.content.length
    a.locations << l
    return a
  end
  
  def generate_bioc_relation_node(node, relation) 
    r = SimpleBioC::Relation.new(node)
    r.id = relation.r_id
    r.infons = relation.infons
    r.infons["type"] = relation.r_type
    r.infons["note"] = relation.note if relation.note.present?
    r.infons["annotator"] = relation.annotator if relation.annotator.present?
    r.infons["updated_at"] = relation.updated_at.utc.iso8601
    relation.nodes.each do |n|
      node = SimpleBioC::Node.new(r)
      node.refid = n.ref_id
      node.role = n.role
      r.nodes << node
    end
    return r
  end

  def start_round(version, collaborate = false)
    Document.transaction do 
      self.version = version
      self.save
      Annotation.execute_sql("DELETE FROM annotations WHERE document_id = ? and version = ?", self.id, version)
      Relation.execute_sql("DELETE FROM nodes WHERE document_id = ? and version = ?", self.id, version)
      Relation.execute_sql("DELETE FROM relations WHERE document_id = ? and version = ?", self.id, version)

      if collaborate
        self.assigns[0].copy_previous_versions
      else
        self.assigns.each{|a| a.copy_previous_versions}
      end
    end
  end

  # def init_review_result(assign)
  #   prev_annotations = self.annotations.where("version = ?", self.version - 1).order('offset ASC, content ASC').all
  #   annotations = self.annotations.where("version = ? AND assign_id = ?", self.version, assign.id).order('offset ASC, content ASC').all
  #   agreed = []
  #   annotations.each do |a|
  #     same_annotations = prev_annotations.select{|p| p.offset == a.offset && p.content == a.content && p.a_type == a.a_type && p.concept == a.concept}
  #     if same_annotations.size == self.assigns.size
  #       agreed << a.id
  #     end
  #   end
  #   Annotation.execute_sql("UPDATE annotations SET review_resuflt = 1 WHERE id IN (?) ", agreed);
  # end

  def final_review_result
    list = self.annotations.where("version = ?", self.version).map{|a| a}
    ranges = []
    list.each do |a|
      a.review_result = "not_determined"
      ranges << a.offset
      ranges << a.offset + a.content.size
    end
    ranges = ranges.sort.uniq

    ranges.each_with_index do |s_pos, idx|
      next if idx == ranges.size - 1
      e_pos = ranges[idx + 1]
      a_in_range = []
      concepts = []
      contents = []
      entity_types = []
      list.each do |a|
        ss = a.offset
        ee = a.content.size + ss
        if ee > s_pos && e_pos > ss
          concepts << a.concept
          entity_types << a.a_type
          contents << a.content
          a_in_range << a
        end
      end
      concepts = concepts.uniq
      entity_types = entity_types.uniq
      contents = contents.uniq

      # logger.debug("CONCEPTS = #{concepts} / entity_types = #{entity_types} / contents = #{contents}")
      if concepts.size > 1 || entity_types.size > 1 || contents.size > 1
        a_in_range.each{|a| a.review_result = "disagreed" }
      elsif a_in_range.size != self.assigns.size && !self.project.collaborate_round
        a_in_range.each{|a| a.review_result = "disagreed" }
      else
        a_in_range.each do |a| 
          logger.debug("a_in_range = #{a_in_range.size}, assign = #{self.assigns.size}, a_review_result = #{a.review_result}")
          a.review_result = "agreed" if a.review_result == "not_determined"      
        end
      end
    end
    agreed_ids = []
    disagreed_ids = []
    other_ids = []
    list.each do |a|
      if a.review_result == "agreed"
        agreed_ids << a.id
      elsif a.review_result == "disagreed"
        disagreed_ids << a.id
      else
        other_ids << a.id
      end
    end
    Annotation.execute_sql("UPDATE annotations SET review_result = 1 WHERE id IN (?) ", agreed_ids);
    Annotation.execute_sql("UPDATE annotations SET review_result = 2 WHERE id IN (?) ", disagreed_ids);
    Annotation.execute_sql("UPDATE annotations SET review_result = 0 WHERE id IN (?) ", other_ids);
  end

  def final_merge_result
    list = self.annotations.where("version = ?", self.version).map{|a| a}
    ranges = []
    list.each do |a|
      a.review_result = "agreed"
      ranges << a.offset
      ranges << a.offset + a.content.size
    end
    ranges = ranges.sort.uniq

    ranges.each_with_index do |s_pos, idx|
      next if idx == ranges.size - 1
      e_pos = ranges[idx + 1]
      a_in_range = []
      concepts = []
      contents = []
      entity_types = []
      list.each do |a|
        ss = a.offset
        ee = a.content.size + ss
        if ee > s_pos && e_pos > ss
          concepts << a.concept
          entity_types << a.a_type
          contents << a.content
          a_in_range << a
        end
      end
      concepts = concepts.uniq
      entity_types = entity_types.uniq
      contents = contents.uniq

      # logger.debug("CONCEPTS = #{concepts} / entity_types = #{entity_types} / contents = #{contents}")
      if concepts.size > 1 || entity_types.size > 1 || contents.size > 1
        a_in_range.each{|a| a.review_result = "disagreed" }
      end
    end
    agreed_ids = []
    disagreed_ids = []
    list.each do |a|
      if a.review_result == "agreed"
        agreed_ids << a.id
      elsif a.review_result == "disagreed"
        disagreed_ids << a.id
      end
    end
    Annotation.execute_sql("UPDATE annotations SET review_result = 1 WHERE id IN (?) ", agreed_ids);
    Annotation.execute_sql("UPDATE annotations SET review_result = 2 WHERE id IN (?) ", disagreed_ids);
  end

  def annotation_stat(version)
    list = self.annotations.where("version = ?", version).map{|a| a }
    occurrences = []
    list.each do |a|
      ss = a.offset
      ee = a.offset + a.content.size
      o = occurrences.select{|o| o[:ee] > ss && ee > o[:ss] }.first     
      if o.nil?
        occurrences << {ss: ss, ee: ee, items: [a]}
      else
        o[:ss] = [o[:ss], ss].min
        o[:ee] = [o[:ee], ee].max
        o[:items] << a
      end
    end

    ret = {
      "full_agree": 0,
      "agree_concept": 0, 
      "agree_type": 0,
      "single": 0,
      "partial": 0, 
      "disagree": 0,
      "total": occurrences.size, 
    }

    logger.debug(occurrences.map{|a| a[:items].map{|a| a.content}.join(" | ")}.join("\n"))
    i = 1
    occurrences.each do |o|
      types = o[:items].map{|a| a.a_type}.uniq
      concepts = o[:items].map{|a| a.concept}.uniq
      offsets = o[:items].map{|a| "#{a.offset}|#{a.content}"}.uniq
      if self.assigns.size > o[:items].size && !self.project.collaborates[version]
        # single annotation
        o[:result] = 'single'
      elsif types.size == 1 && concepts.size == 1 && offsets.size == 1
        o[:result] = 'full_agree'
      elsif types.size == 1 && offsets.size == 1
        o[:result] = 'agree_type'
      elsif concepts.size == 1 && offsets.size == 1
        o[:result] = 'agree_concept'
      elsif concepts.size == 1 && types.size == 1 
        o[:result] = 'partial'
      elsif offsets.size == 1
        o[:result] = 'disagree'
      else
        o[:result] = 'disagree'
      end
      logger.debug("#{i} : \ttypes: #{types}, \tconcepts: #{concepts}, \toffset: #{offsets} \t\t--> #{o[:result]}")
      i += 1
      ret[o[:result].to_sym] += 1
    end
    ret
  end

  def relation_stat(version)
    annotation_map = {}
    self.annotations.where("version = ?", version).each{|a| annotation_map[a.a_id] = a }
    realtion_map = {}
    self.relations.where("version = ?", version).each{|r| realtion_map[r.r_id] = r }
    keys = {}
    realtion_map.each do |k, r|
      Rails.logger.debug(r.inspect)
      k = r.find_relation_sig(annotation_map, realtion_map, [])
      key = keys[k]
      if key.present?
        key << r
      else
        keys[k] = [r]
      end
    end
    
    ret = {
      "agree": 0,
      "disagree": 0,
      "single": 0,
      "total": keys.size, 
    }

    keys.each do |k, list|
      types = list.map{|r| r.r_type}.uniq
      
      if self.assigns.size > list.size && !self.project.collaborates[version]
        ret[:single] += 1
      elsif types.size == 1
        ret[:agree] += 1
      else
        ret[:disagree] += 1
      end
    end
    ret
  end
  def simple_merge
    Document.transaction do 
      dups = Annotation.execute_sql("
        SELECT a_type, concept, offset, content, annotator
        FROM annotations
        WHERE version = ? AND document_id = ? AND annotator != ''
        GROUP BY a_type, concept, offset, content, annotator
        HAVING count(*) > 1
        ", self.version, self.id)

      delete_ids = []
      dups.each do |d|
        rows = Annotation.execute_sql("
          SELECT id, a_id FROM annotations
          WHERE a_type=? AND concept=? AND offset=? AND content=? and annotator = ?
                AND version = ? AND document_id = ?
          ORDER BY a_id ASC
          ", d[0], d[1], d[2], d[3], d[4], self.version, self.id)

        to_id = nil
        rows.each do |r|
          if to_id.nil?
            to_id = r[1]
          else
            delete_ids << r[0]
            Node.execute_sql("
              UPDATE nodes SET ref_id = ? 
              WHERE ref_id = ? AND document_id = ? AND version = ?
              ", to_id, r[1], self.id, self.version)

          end
        end
      end
      Annotation.execute_sql("DELETE FROM annotations WHERE id in (?)", delete_ids)
      self.final_review_result

      self.relations.where("version=?", self.version).all.each do |r|
        r.update_signature
      end
      dups = Document.execute_sql("
        SELECT r_type, sig1, annotator
        FROM relations
        WHERE version = ? AND document_id = ?
        GROUP BY r_type, sig1, annotator
        HAVING count(*) > 1
        ", self.version, self.id)

      delete_ids = []
      dups.each do |d|
        rows = Document.execute_sql("
          SELECT id, r_id FROM relations
          WHERE r_type=? AND sig1=? AND annotator=?  
                AND version = ? AND document_id = ?
          ORDER BY r_id ASC
          ", d[0], d[1], d[2],  self.version, self.id)

        to_id = nil
        rows.each do |r|
          if to_id.nil?
            to_id = r[1]
          else
            delete_ids << r[0]
          end
        end
      end
      Relation.execute_sql("DELETE FROM nodes WHERE relation_id in (?)", delete_ids)
      Relation.execute_sql("DELETE FROM relations WHERE id in (?)", delete_ids)
    end
  end

  def final_merge(version)
    version = version || self.project.version
    version = version.to_i
    version += 1
    Document.transaction do 
      self.version = version
      self.save
      Annotation.execute_sql("DELETE FROM annotations WHERE document_id = ? and version = ?", self.id, version)
      Node.execute_sql("DELETE FROM nodes WHERE document_id = ? and version = ?", self.id, version)
      Relation.execute_sql("DELETE FROM relations WHERE document_id = ? and version = ?", self.id, version)
      
      Annotation.execute_sql("   
        INSERT INTO annotations(
          a_id, a_id_no, a_type, concept,  
          user_id, content, note, offset, passage, 
          document_id, annotator, version, infons,
          assign_id, created_at, updated_at, review_result
        ) 
        SELECT 
          a_id, a_id_no, a_type, concept, 
          NULL, content, note, offset, passage, 
          document_id, annotator, (version + 1), infons,
          NULL, created_at, updated_at, 4
        FROM annotations
        WHERE 
          document_id = ? AND
          version = ?
        ", self.id, self.version - 1
      )

      self.relations.where("version = ?", self.version - 1).all.each do |r|
        new_r = self.relations.create({
          r_id: r.r_id,
          r_type: r.r_type,
          note: r.note,
          infons: r.infons,
          annotator: r.annotator,
          document_id: r.document_id,
          r_id_no: r.r_id_no,
          version: r.version + 1,
          created_at: r.created_at,
          updated_at: r.updated_at,
          sig1: r.sig1,
          sig2: r.sig2
        });
        Node.execute_sql("
          INSERT INTO nodes(
            relation_id, order_no, role, created_at, updated_at, ref_id, document_id, version
          ) 
          SELECT 
            #{new_r.id}, order_no, role, created_at, updated_at, ref_id, document_id, #{new_r.version}
          FROM nodes
          WHERE 
            relation_id = ? AND
            version = ?
          ", r.id, self.version - 1)
      end

      dups = Document.execute_sql("
        SELECT a_type, concept, offset, content
        FROM annotations
        WHERE version = ? AND document_id = ?
        GROUP BY a_type, concept, offset, content
        HAVING count(*) > 1
        ", self.version, self.id)

      delete_ids = []
      dups.each do |d|
        rows = Document.execute_sql("
          SELECT id, a_id, annotator FROM annotations
          WHERE a_type=? AND concept=? AND offset=? AND content=?
               AND version = ? AND document_id = ?
          ORDER BY a_id ASC
          ", d[0], d[1], d[2], d[3], self.version, self.id)

        to_id = nil
        names = []
        rows.each do |r|
          if to_id.nil?
            to_id = r[0]
            to_a_id = r[1]
          else
            delete_ids << r[0]
            Node.execute_sql("
              UPDATE nodes SET ref_id = ? 
              WHERE ref_id = ? AND document_id = ? AND version = ?
              ", to_a_id, r[1], self.id, self.version)
          end
          names.push(*r[2].split(","))
        end
        Annotation.execute_sql("UPDATE annotations SET annotator = ? WHERE id = ?", names.uniq.sort.join(','), to_id)
      end
      Annotation.execute_sql("DELETE FROM annotations WHERE id in (?)", delete_ids)
      
      self.final_merge_result

      self.relations.where("version=?", self.version).all.each do |r|
        r.update_signature
      end
      
      dups = Document.execute_sql("
        SELECT r_type, sig1
        FROM relations
        WHERE version = ? AND document_id = ?
        GROUP BY r_type, sig1
        HAVING count(*) > 1
        ", self.version, self.id)

      delete_ids = []
      dups.each do |d|
        rows = Document.execute_sql("
          SELECT id, r_id, annotator FROM relations
          WHERE r_type=? AND sig1=? 
               AND version = ? AND document_id = ?
          ORDER BY r_id ASC
          ", d[0], d[1], self.version, self.id)

        to_id = nil
        names = []
        rows.each do |r|
          if to_id.nil?
            to_id = r[0]
            to_a_id = r[1]
          else
            delete_ids << r[0]
          end
          names.push(*r[2].split(","))
        end
        Relation.execute_sql("UPDATE relations SET annotator = ? WHERE id = ?", names.uniq.sort.join(','), to_id)
      end
      Relation.execute_sql("DELETE FROM relations WHERE id in (?)", delete_ids)
    end
  end

  def detach_annotations_relations(version = nil)
    version = self.version if version.nil?
    relation_types = {}
    self.project.relation_types.each{|r| relation_types[r.name.upcase] = r}
    Document.transaction do 
      self.annotations.where('`version`=?', version).destroy_all
      self.relations.where('`version`=?', version).destroy_all
      self.infons = self.bioc_doc.infons
      p_offset = self.bioc_doc.passages.map{|p, index| p.offset.to_i }
      # logger.debug(p_offset.inspect)
      # logger.debug(self.bioc_doc.all_annotations.size)
      self.bioc_doc.all_annotations.each do |a|
        entity = EntityUtil.get_annotation_entity(a)
        text = a.text
        a.locations.each do |l|
          p_idx = 0
              
          while p_idx < p_offset.size
            break if p_offset[p_idx] > l.offset.to_i
            p_idx += 1
          end
          p_idx -= 1 if p_idx > 0

          a_type = a.infons['type'] || ""
          concept = a.infons['identifier'] || ""

          if a_type.present? 
            entity_type = self.project.entity_type(a_type)
          end
          concept = self.project.normalize_concept_id(concept, a_type)

          annotation = self.annotations.create!({
            a_id: a.id,
            a_id_no: (a.id || "-1").to_i,
            a_type: a_type,
            concept: concept,
            content: a.text,
            offset: l.offset,
            passage: p_idx,
            note: a.infons["note"] || "",
            annotator: a.infons["annotator"] || "",
            created_at: a.infons["updated_at"] || "1980-01-01",
            updated_at: a.infons["updated_at"] || "1980-01-01",
            infons: a.infons,
            document_id: self.id,
            project_id: self.project_id,
            version: version
          })
        end
      end
      self.bioc_doc.all_relations.each do |r|
        relation = self.relations.create!({
          r_id: r.id,
          r_id_no: Relation.r_id_to_num(r.id),
          r_type: r.infons['type'] || "",
          note: r.infons["note"] || "",
          annotator: r.infons["annotator"] || "",
          created_at: r.infons["updated_at"] || "1980-01-01",
          updated_at: r.infons["updated_at"] || "1980-01-01",
          infons: r.infons,
          document_id: self.id,
          version: version
        })
        r.nodes.each_with_index do |n, idx|
          relation.nodes.create!({
            document_id: self.id,
            version: version,
            order_no: idx + 1,
            role: n.role,
            ref_id: n.refid
          })
        end

        if relation_types[relation.r_type.upcase].nil?
          relation_type = self.project.relation_types.create!({name: relation.r_type})
          relation_types[relation_type.name.upcase] = relation_type
        end
      end
      self.xml_at = Time.now
      self.save
    end
  end

  def merge_xml(version = nil, current_user = nil)
    version = self.version if version.nil?

    annotations = self.annotations.where('`version`=?', version).order('offset').all
    relations = self.relations.where('`version`=?', version).all
    added_relations = []
    self.bioc_doc.passages.each do |p|
      p.annotations.clear
      p.relations.clear
      if p.sentences.blank? && p.text.present?
        a_ids = []
        annotations.each do |annotation|
          next if annotation.offset < p.offset || annotation.offset + annotation.content.size > (p.offset + p.text.length)
          a = generate_bioc_annotation_node(p, annotation)
          a_ids << annotation.a_id
          p.annotations << a
        end
        relations.each do |relation|
          next unless relation.ref_in?(a_ids)
          r = generate_bioc_relation_node(p, relation)
          p.relations << r
          added_relations << relation.r_id
        end
      else
        p.sentences.each do |s|
          s.annotations.clear
          s.relations.clear
          annotations.each do |annotation|
            next if annotation.offset < s.offset || annotation.offset + annotation.content.size > (s.offset + s.text.length)
            a = generate_bioc_annotation_node(s, annotation)
            a_ids << annotation.a_id
            s.annotations << a
          end
          relations.each do |relation|
            next unless relation.ref_in?(a_ids)
            r = generate_bioc_relation_node(s, relation)
            s.relations << r
            added_relations << relation.r_id
          end
        end
      end
    end
    self.bioc_doc.relations.clear
    relations.each do |relation|
      next if added_relations.include?(relation.r_id)
      r = generate_bioc_relation_node(self.bioc_doc, relation)
      self.bioc_doc.relations << r
    end
    self.bioc_doc.infons = self.bioc_doc.infons.merge(self.infons || {})
    self.bioc_doc.relations
    self.adjust_offset(true)
    self.bioc_doc.infons['tt_curatable'] = self.curatable_value
    self.bioc_doc.infons['tt_version'] = version
    self.bioc_doc.infons['tt_round'] = self.project.round
    if self.project.reviewing?
      self.bioc_doc.infons['tt_review'] = if self.determined? then 1 else 0 end
    else
      self.bioc_doc.infons.delete('tt_review')
    end
    if current_user.present? && self.project.manager?(current_user)
      if self.assigns.present? 
        self.bioc_doc.infons['tt_annotators'] = self.assigns.map do |a|
          "#{a.user.email_or_name}|C:#{if a.curatable then 1 else 0 end}|D:#{if a.done then 1 else 0 end}"
        end.join(",")
      end

    else
      self.bioc_doc.infons.delete('tt_annotators')
    end
    SimpleBioC.to_xml(bioc)
  end

  def get_xml(version = nil)
    if version.nil? || self.version == version
      if self.xml_at.present? && self.xml_at >= self.updated_at && false
        xml = self.xml
      else
        xml = self.merge_xml(version)
        self.xml = xml
        self.xml_at = Time.now
        self.save
      end
    else
      xml = self.merge_xml(version)
    end
    xml
  end
  
  def get_json(version = nil)
    xml = self.get_xml(version)
    @bioc = SimpleBioC.from_xml_string(xml)
    SimpleBioC.to_pubann(@bioc)
  end

  def save_xml(bioc)
    self.adjust_offset(true)
    self.xml = SimpleBioC.to_xml(bioc)
    self.save
    self.handle_update_xml(nil)
  end

  def gen_id
    max = 0
    self.annotations.select('a_id').each do |a| 
      no = a.a_id.to_i
      max = no if no > max
    end
    "#{max + 1}"
  end

  def find_same_annotation(annotations, annotation, pattern)
    annotations.each do |a|
      if a.content.index(pattern) == 0 && a.content.size = annotation.size
        return a
      end
    end
  end

  def annotate_all_by_text_into_db(assign, user, annotator, text, entity_type, concept, case_sensitive, whole_word, review_result, note)
    if assign.present?
      assign_id = assign.id
      exist_annotations = assign.annotations
      exist_offsets = assign.annotations.all.map {|a| a.offset}.uniq
    else
      assign_id = nil
      exist_annotations = self.annotations
      exist_offsets = self.annotations.all.map{|a| a.offset}.uniq
    end

    result = []
    if whole_word && case_sensitive
      pattern = /\b#{Regexp.escape(text)}\b/
    elsif whole_word
      pattern = /\b#{Regexp.escape(text)}\b/i
    elsif case_sensitive
      pattern = /#{Regexp.escape(text)}/
    else
      pattern = /#{Regexp.escape(text)}/i
    end
    Document.transaction do 
      max_id = self.annotations.maximum('a_id_no');
      p_idx = 0
      self.bioc_doc.passages.each do |p|
        if p.text.nil?
          p.sentences.each do |s|
            update_contents(s, pattern, text, entity_type, concept, user, annotator, note, p_idx, assign_id, review_result,
              exist_annotations, exist_offsets, result
            )
          end
        else 
          update_contents(p, pattern, text, entity_type, concept, user, annotator, note, p_idx, assign_id, review_result,
            exist_annotations, exist_offsets, result
          )
          p_idx += 1
        end
      end
      return result
    end
  end

  def update_contents(obj, pattern, text, entity_type, concept, user, annotator, note, p_idx, assign_id, review_result, exist_annotations, exist_offsets, result)
    max_id = self.annotations.maximum('a_id_no');
    positions = find_all_locations(obj, pattern)
    positions.each do |offset|
      if exist_offsets.include?(offset)
        found = exist_annotations.select{|a| a.offset == offset && a.content.length == text.length && a.content.index(pattern) == 0}
        found.each do |a|
          a.review_result = review_result
          a.concept = concept
          a.a_type = entity_type
          a.note = note
          a.annotator = annotator
          a.user_id = user.id
          a.save
          result << a.id
        end
        next if found.present?
      end
      max_id += 1
      a = Annotation.create!({
        a_id: max_id,
        a_id_no: max_id,
        a_type: entity_type, 
        concept: concept,
        user_id: user.id,
        content: obj.text[offset - obj.offset, text.length],
        note: note,
        offset: offset,
        passage: p_idx,
        assign_id: assign_id,
        document_id: self.id,
        project_id: self.project_id,
        annotator: annotator,
        review_result: review_result,
        version: self.version,
        infons: {}
      });
      result << a.id
    end
  end

  def annotations_count(user)
    if self.project.manager?(user) || self.project.collaborate_round
      self.annotations.where('`version`=?', self.version).size
    else
      assign = self.assigns.where('user_id = ?', user.id).first
      if assign.detached
        self.annotations.where('`version`=? AND assign_id = ?', self.version, assign.id).size
      else
        self.annotations.where('`version`=?', self.version).size
      end
    end
  end
  
  def has_annotations?
    !self.annotations.where('`version`=?', self.version).empty?
  end

  def is_done?
    assigns.where('done=false').empty?
  end

  def delete_all_annotations
    Document.transaction do 
      Node.execute_sql("
        DELETE FROM nodes WHERE document_id = ? and version = ?
      ", self.id, self.version)
      Relation.execute_sql("
        DELETE FROM relations WHERE document_id = ? and version = ?
      ", self.id, self.version)
      Annotation.execute_sql("
        DELETE FROM annotations WHERE document_id = ? and version = ?
      ", self.id, self.version)
      Assign.execute_sql("
        UPDATE assigns SET annotations_count=0 WHERE document_id = ?
        ", self.id)
    end
    return true
  end

  def bioc
    if @bioc.nil?
      # Rails.logger.debug(self.xml)
      @bioc = SimpleBioC.from_xml_string(self.xml)
    end
    @bioc
  end
  
  def bioc_doc
    self.bioc.documents[0]
  end

  def adjust_offset(needFix)
    doc = self.bioc_doc
    doc.passages.each do |p|
      adjust_annotation_offsets(p, needFix)
      p.sentences.each do |s|
        adjust_annotation_offsets(s, needFix)
      end
    end
  end

  def adjust_annotation_offsets(obj, needFix)
    return if obj.nil? || obj.annotations.nil?
    ret = []
    obj.annotations.each do |a|
      positions = find_all_locations(obj, a.text)
      next if a.locations.nil?
      a.locations.each do |l|
        next if l.nil? || l == false
        candidate = choose_offset_candidate(l.offset, positions)
        if candidate.to_i != l.offset.to_i
          val = a.infons["error:misaligned:#{a.id}"] || ""
          arr = val.split(",")
          arr << "#{l.offset}->#{candidate}"
          a.infons["error:misaligned:#{a.id}"] = arr.join(",")
          ret << [a.id, l.offset, l.length, candidate]
          if needFix
            l.offset = candidate
          end
        end
      end
    end
    return ret
  end
  
  def atype(name)
    self.project.entity_type(name)
  end

  def find_all_locations(obj, text)
    positions = []
    return positions if obj.nil? || obj.text.nil?
    pos = obj.text.index(text)
    until pos.nil? 
      positions << (pos + obj.offset)
      pos = obj.text.index(text, pos + 1)
    end
    return positions
  end

  def choose_offset_candidate(offset, positions)
    return offset if positions.nil?
    min_diff = 99999
    offset = offset.to_i
    ret = offset
    positions.each do |p|
      diff = (offset - p).abs
      if diff < min_diff
        ret = p 
        min_diff = diff
      end
    end
    return ret
  end

  def handle_update_xml(doc)
    if doc.nil?
      doc = self.bioc_doc
    end
    self.save
  end

  def get_psize(p)
    self.get_ptext(p).size
  end

  def get_ptext(p)
    if p.text.blank?
      p.sentences.map{|s| s.text}.join(" ")
    else
      p.text
    end
  end
  def get_class_from_passage(p)
    cls = []
    p.annotations.each do |a|
      cls = cls | [get_class_from_annotation(a)]
    end
    p.sentences.each do |s|
      s.annotations.each do |a|
        cls = cls | [get_class_from_annotation(a)]
      end
    end
    return cls.uniq
  end
  def get_class_from_annotation(a)
    type = a.infons['type']
    cls_name = case type.downcase
    when 'gene'
      "G"
    when 'organism'
      "O"
    when 'ppimention','ppievidence'
      "EP"
    when 'geneticinteractiontype', 'gievidence', 'gimention'
      "EG"
    when 'experimentalmethod'
      "EM"
    when 'none'
      ""
    else
      "E"
    end unless type.nil?

    return cls_name
  end
  def outline
    root = {children: []}
    last_in_levels = [root]
    last_item = nil
    self.bioc_doc.passages.each_with_index do |p, index|
      next if p.infons["type"].nil?

      result = p.infons["type"].match(/title_(\d+)/)
      if result.present?
        level = result[1].strip.to_i
        item_text = "title"
      elsif %w(front abstract title).include?(p.infons["type"])
        level = 1
        item_text = p.infons["type"]
      else
        if !last_item.nil?
          next
        else
          level = 1
          item_text = p.infons["type"]
        end
      end

      desc = self.get_ptext(p)[0..30] 
      item = {id: index, text: item_text, description: desc, children: [], level: level}
      
      last_item = item
      last_in_levels[level] = item
      plevel = level - 1
      while (plevel > 0 && last_in_levels[plevel].nil?) do
        plevel = plevel - 1
      end
      p = last_in_levels[plevel]
      p[:children] << item
    end
    # Rails.logger.debug(root.inspect)
    root[:children]
  end

  def verify
    result = []
    id_map = {}
    if self.annotations.size > 0

      doc = self.bioc_doc
      doc.passages.each do |p|
        p.sentences.each do |s|
          check_duplicated_id(s.annotations, result, 'annotation', id_map)
          check_duplicated_id(s.relations, result, 'annotation', id_map)
        end
        check_duplicated_id(p.annotations, result, 'annotation', id_map)
        check_duplicated_id(p.relations, result, 'annotation', id_map)
      end
      doc.passages.each do |p|
        p.sentences.each do |s|
          check_annotation_location(s, result)
          check_relation_ref(s, result, id_map)
        end
        check_annotation_location(p, result) unless p.text.nil?
        check_relation_ref(p, result, id_map)
      end

      result
    else
      []
    end
  end

  def check_duplicated_id(coll, result, type, id_map)
    coll.each do |n|
      if id_map[n.id].nil?
        id_map[n.id] = 1
      else
        result << "The annotation ID '#{n.id}' is duplicated"
      end
    end
  end

  def check_annotation_location(obj, result)
    misaligned = adjust_annotation_offsets(obj, true)
    misaligned.each do |item|
      result << "The annotation #{item[0]} is misaligned [#{item[1]}:#{item[2]}] (auto-fixed to [#{item[3]}:#{item[2]}])"
    end
    obj.annotations.each do |a|
      a.locations.each do |l|
        start_pos = l.offset.to_i - obj.offset
        end_pos = start_pos + l.length.to_i
        text = obj.text[start_pos...end_pos]
        if text != a.text
          result <<  "The annotation #{a.id} is misaligned [#{l.offset}:#{l.length}] (the text in annotation '<b>#{a.text}</b>' is different from the one at the location '<b>#{text}</b>')"
        end
      end
    end
  end

  def check_relation_ref(obj, result, id_map) 
    obj.relations.each do |r|
      r.nodes.each do |n|
        if id_map[n.refid].nil?
          result << "The relation #{r.id} refers non-existing nodes (refid: #{n.refid})"
        end
      end
    end
  end
  
  def correct_pmc_id
    doc = self.bioc_doc
    found = correct_pmc_id_in_infons(doc)
    doc.passages.each do |p|
      next if found
      found = correct_pmc_id_in_infons(p)
      p.sentences.each do |s|
        next if found
        found = correct_pmc_id_in_infons(s)
      end unless found
    end unless found
    
    self.save_xml(self.bioc) if found

    return found
  end

  def has_reference_relation?(ids)
    ret = Document.execute_sql("
      SELECT * 
      FROM nodes 
      WHERE 
        ref_id in (SELECT a_id FROM annotations WHERE id in (?)) 
        and document_id = ? 
        and version = ?
      ", ids, self.id, self.version)
    return ret.size > 0
  end

  private
  def get_first_text_from_bioc(doc)
    doc.passages.each do |p|
      p.sentences.each do |s|
        return s.text
      end
      return p.text
    end
  end

  def id_found?(given_id, id)
    if given_id.kind_of?(Array)
      given_id.include?(id)
    else
      given_id == id
    end
  end

  def offset_same?(given_id, given_offset, id, offset)
    if given_offset.kind_of?(Array)
      found = given_offset.select{|o| o[:id] == id && o[:offset] == offset}
      found.present?
    else
      given_offset.to_i == offset
    end
  end

  def correct_pmc_id_in_infons(node)
    value = node.infons["article-id_pmc"]
    if value.present?
      reg = value.match(/^PMC(\d+)/i)
      if reg.present?
        node.infons["article-id_pmc"] = reg[1]
        return true
      end
    end
    false
  end
end
