require 'open-uri'

class Project < ApplicationRecord
  has_many :project_users, -> { order('role asc')}, dependent: :destroy 
  has_many :users, through: :project_users
  has_many :documents, dependent: :destroy
  has_many :annotations
  has_many :assigns, dependent: :destroy
  has_many :entity_types, dependent: :destroy
  has_many :relation_types, dependent: :destroy
  has_one  :manager, -> { where(role: 0) }, class_name: "ProjectUser"
  has_many :tasks,-> { order 'created_at desc' }, dependent: :destroy
  has_many :lexicon_groups, dependent: :destroy
  has_many :models,-> { order 'created_at desc' }, dependent: :destroy
  has_many :audits,-> { order 'created_at desc' }, dependent: :destroy
  
  validates :name, presence: true
  enum round_state: [:preparing, :annotating, :reviewing]
  serialize :collaborates

  attr_accessor :model_url

  def all_assigned?
    self.documents.where('assigns_count = 0').first.nil?
  end

  def round_available?
    logger.debug(self.status)
    logger.debug(self.all_assigned?)
    self.status == 'preparing' && !self.documents.empty? && self.all_assigned? 
  end

  def round_begin?
    self.annotating? || self.reviewing?
  end

  def role_name
    if self.role == 0
      'Project Manager'
    else
      'Annotator'
    end
  end

  def user_assigns(user)
    self.assigns.where('user_id = ?', user.id)
  end

  def user_documents_count(user)
    docs = self.user_assigns(user)
    docs.size
  end

  def user_done?(user)
    user_undone_count(user) == 0
  end

  def user_done_count(user)
    user_assigns(user).where('done=true').size
  end

  def user_undone_count(user)
    user_assigns(user).where('done=false').size
  end

  def available?(user)
    pu = self.project_users.where('user_id = ?', user.id).first
    return pu.present? || user.super_admin?
  end

  def manager?(user)
    return false unless user.present?
    return true if user.super_admin?
    pu = self.project_users.where('user_id = ?', user.id).first
    return (pu.present? && pu.role == 'project_manager')
  end

  def documents_count_for_display(user)
    if self.manager?(user)
      self.documents_count
    else
      "#{self.user_done_count(user)}/#{self.user_documents_count(user)}"
    end
  end

  def self.load_samples(user)
    Project.transaction do
      sample1 = user.projects.create!({name: 'Gene-Disease Project (sample)', key: 'samples'})
      sample1.entity_types.create({name: 'GENE', color: '#99FF66', prefix: 'GENE:'})
      sample1.entity_types.create({name: 'Disease', color: '#FFCCCC', prefix: 'MESH:'})
      sample1.entity_types.create({name: 'Mutation', color: '#B9EDFF'})
      sample1.relation_types.create({name: 'GeneGene_Interaction', color: '#B2420F', num_nodes: 5, entity_type: 'GENE'})
      user1 = User.new_anonymous_user('alice');
      user2 = User.new_anonymous_user('john');
      sample1.project_users.create({user_id: user1.id, role: 'annotator'})
      sample1.project_users.create({user_id: user2.id, role: 'annotator'})
      sample1.upload_from_file(Rails.root.join("public/samples", "18093912_v0.xml"), 1)
      sample1.upload_from_file(Rails.root.join("public/samples", "11773052_v0.xml"), 1)
      sample1.upload_from_file(Rails.root.join("public/samples", "3757249_v0.xml"), 1)

      if Rails.env.production? 
        p = Project.find(52)
        alice = 122
        john = 121
      else
        p = Project.find(68)
        alice = 54
        john = 55
      end
      sample2 = user.projects.new(p.attributes)
      sample2.id = nil
      sample2.created_at = nil
      sample2.updated_at = nil
      sample2.name = "#{p.name} (sample)"
      sample2.key = 'samples'
      sample2.documents_count = 0
      sample2.project_users_count = 0
      sample2.entity_types_count = 0
      sample2.relation_types_count = 0
      sample2.assigns_count = 0
      sample2.save

      p.entity_types.all.each{|t| sample2.entity_types.create({name: t.name, color: t.color, prefix: t.prefix})}
      p.relation_types.all.each{|t| sample2.relation_types.create({name: t.name, color: t.color, num_nodes: t.num_nodes, entity_type: t.entity_type})}
      pu0 = sample2.project_users.create({user_id: user.id, role: 'project_manager'})
      pu1 = sample2.project_users.create({user_id: user1.id, role: 'annotator'})
      pu2 = sample2.project_users.create({user_id: user2.id, role: 'annotator'})

      p.documents.all.each do |d|
        d2 = sample2.documents.create({
          did: d.did, xml: d.xml, title: d.title, key: d.key, did_no: d.did_no,
          batch_id: d.batch_id, batch_no: d.batch_no, order_no: d.order_no, assigns_count: 0,
          version: d.version, xml_at: d.xml_at, done_count: d.done_count
        })
        old_assign1 = d.assigns.where('user_id = ?', alice).first
        old_assign2 = d.assigns.where('user_id = ?', john).first
        assign1 = d2.assigns.create({
          project_id: sample2.id, user_id: user1.id, done: old_assign1.done, curatable: old_assign1.curatable, 
          begin_at: old_assign1.begin_at, end_at:old_assign1.end_at, 
          project_user_id: pu1.id, detached: old_assign1.detached, annotations_count: 0
        })
        assign2 = d2.assigns.create({
          project_id: sample2.id, user_id: user2.id, done: old_assign2.done, curatable: old_assign2.curatable, 
          begin_at: old_assign2.begin_at, end_at:old_assign2.end_at, 
          project_user_id: pu2.id, detached: old_assign2.detached, annotations_count: 0
        })
        d.annotations.all.each do |a|
          a2 = d2.annotations.new(a.attributes)
          a2.updated_at = a2.created_at = a2.id = nil
          a2.user_id = user1.id if a.user_id == alice
          a2.user_id = user2.id if a.user_id == john
          a2.assign_id = assign1.id if a.assign_id == old_assign1.id
          a2.assign_id = assign2.id if a.assign_id == old_assign2.id
          a2.save
        end
        d.relations.all.each do |r|
          r2 = d2.relations.new(r.attributes)
          r2.updated_at = r2.created_at = r2.id = nil
          r2.user_id = user1.id if r.user_id == alice
          r2.user_id = user2.id if r.user_id == john
          r2.assign_id = assign1.id if r.assign_id == old_assign1.id
          r2.assign_id = assign2.id if r.assign_id == old_assign2.id
          r2.save
          r.nodes.all.each do |n|
            n2 = r2.nodes.new(n.attributes)
            n2.updated_at = n2.created_at = n2.id = nil
            n2.relation_id = r2.id
            n2.document_id = d2.id
            n2.save
          end
        end
      end
    end
  end

  def start_round(collaborate = false)
    Project.transaction do 
      self.round_state = if self.round > 0 then "reviewing" else "annotating" end
      self.round += 1
      # self.documents.each{|d| d.start_round(self.round)}
      self.done = false
      self.assigns.update_all(done: false, annotations_count: 0)
      self.documents.update_all(done_count: 0)
      self.locked = false
      self.collaborates = [] if self.collaborates.nil?
      self.collaborates << collaborate
      self.collaborate_round = collaborate
      self.save
      return true
    end
  end

  def end_round
    Project.transaction do 
      # self.documents.each{|d| d.simple_merge}
      self.round_state = "preparing"
      self.locked = false
      self.save
    end
    return true
  end

  def final_merge
    Project.transaction do 
      # self.documents.each{|d| d.simple_merge}
      self.round += 1
      self.finalized = true
      self.locked = false
      self.save
    end
    return true
  end

  def check_done
    ret = Project.execute_sql("
      SELECT COUNT(*) FROM assigns WHERE project_id = ? AND done=false
      ", self.id)
    self.done = (ret.first.present? && ret.first[0] == 0)
    self.save
    if self.done
      UserMailer.with(project: self).project_done.deliver_later
    end
  end

  def upload_from_file(file, batch_id, replace_did = nil)
    begin
      Project.transaction do 
        if replace_did.present?
          self.documents.where("did = ?", replace_did).destroy_all
        end
        if file.respond_to?(:read)
          logger.debug("HERE?? file.read")
          content = file.read
        elsif file.respond_to?(:path)
          logger.debug("HERE?? File.read file path #{File.extname(file.path)}")
          content = File.read(file.path)
        else
          logger.error "Bad file: #{file.class.name}: #{file.inspect}"
          return ["Failed to read file", nil]
        end
        logger.debug("*************** #{check_filetype(file)} **********************")
        if check_filetype(file) == "xml"
          begin
            bioc = SimpleBioC.from_xml_string(content)
          rescue => error
            Rails.logger.debug(error)
            return [error, nil]
          end
        elsif check_filetype(file) == "pdf"
          basename = File.basename(file.tempfile.path, ".*")
          tmpdir = Dir.tmpdir()
          txtpath = File.join(tmpdir, "#{basename}.txt")
          Docsplit.extract_text(file.tempfile.path, {:pdf_opts => '', output: tmpdir})
          content = File.read(txtpath)
          content = content.gsub(/[^\u{0009}\u{000a}\u{000d}\u{0020}-\u{D7FF}\u{E000}-\u{FFFD}]+/u, ' ')
          bioc = txt2bioc(content, "\n\n")
        else
          bioc = txt2bioc(content)
        end
        
        dids = []
        batch_no = 1
        bioc.documents.each do |d|
          doc = Document.new
          doc.batch_id = batch_id
          doc.batch_no = batch_no
          doc.order_no = 999999
          doc.save_document(d, bioc, self)
          dids << doc.did
          batch_no += 1
        end
        return [nil , dids]   
      end
    rescue => e
      Rails.logger.debug(e.inspect)
      Rails.logger.debug(e.backtrace.join("\n"))
      return [e, nil]
    end
  end

  def upload_from_pmids(pmids, batch_id, id_map)
    logger.debug("PMID=#{pmids.inspect} | batch_id = #{batch_id} | id_map = #{id_map.inspect}")

    begin
      begin
        if pmids.size > 0 && pmids[0].start_with?('PMC')
          url = "https://www.ncbi.nlm.nih.gov/bionlp/RESTful/pmcoa.cgi/BioC_xml/#{URI.escape(pmids.join('|'))}/unicode"
          logger.debug("URL == #{url}")
        else
          url = "https://www.ncbi.nlm.nih.gov/bionlp/RESTful/pubmed.cgi/BioC_xml/#{URI.escape(pmids.join('|'))}/unicode"
        end
        xml = open(url).read
        logger.debug(xml)
        bioc = SimpleBioC.from_xml_string(xml)
      rescue Nokogiri::XML::SyntaxError => e
        Rails.logger.debug(e)
        puts "caught exception: #{e}"
        return [e, nil]
      rescue => error
        Rails.logger.debug(error)
        puts "caught exception: #{e2}"
        return [error, nil]
      end
      dids = []
      bioc.documents.each do |d|
        doc = Document.new
        if bioc.source == "PMC"
          did = "PMC#{d.id}"
        else
          did = d.id
        end
        doc.batch_id = batch_id
        doc.batch_no = id_map[did]
        doc.order_no = 999999
        doc.save_document(d, bioc, self)
        dids << did
      end
      return [nil, dids]
    rescue => e
      Rails.logger.debug(e)
      return [error, nil]
    end
  end

  def update_annotation_count
    results = ActiveRecord::Base.connection.execute("
      UPDATE projects SET annotations_count = IFNULL((
        SELECT sum(annotations_count) 
        FROM documents 
        WHERE project_id = #{self.id}
      ), 0)
      WHERE id = #{self.id}
    ")
  end

  def create_task(params)
    # return nil if self.busy?
    task = nil
    val = params[:task]
    Project.transaction do 
      # self.lock
      # self.save_all_xml

      task = self.tasks.new
      task.project_id = self.id

      mode = val[:task_type] || "0"
      mode = mode.to_i
      task.task_type = mode

      if mode == 1
        # training
        task.tagger = "TaggerOne"
        model = Model.new
        model.project_id = self.id
        model.name = params[:output_model_name] || "No name"
        model.save
        task.model_id = model.id
        task.has_model = true
        if val[:lexicon_group_id] != "0"
          task.lexicon_group_id = val[:lexicon_group_id].to_i
          task.has_lexicon_group = true
        end
      else
        # annotating
        if params[:with] == "model" 
          task.tagger = "TaggerOne"
          task.task_type = 2
          if pre_trained_model?(val[:model])
            task.pre_trained_model = val[:model]
          elsif val[:model] != "0"
            task.model_id = val[:model].to_i
            task.has_model = true
          end
        elsif params[:with] == "lexicon" 
          task.tagger = "Lexicon"
          task.lexicon_group_id = val[:lexicon_group_id].to_i
          task.has_lexicon_group = true
        end
      end
      task.status = "requested" 
      if task.save
        return task
      else
        logger.debug(task.errors.inspect)
      end
      return task
    end
    return nil
  end

  def reorder_concept_id(ids)
    if ids.include?(';')
      ids = ids.split(';').map{|str| self.reorder_concept_id(str)}
      return ids.compact.join(';')
    elsif ids.include?(',')
      ids = ids.split(',').map{|str| self.reorder_concept_id(str)}
      return ids.compact.map{|a| a.to_s}.sort.join(',')
    else
      return ids.strip
    end
  end

  def normalize_concept_id(concept, a_type)
    entity_type = self.entity_type(a_type)
    idx = concept.index(':') 
    if idx.nil?
      type = ""
      ids = concept
    else
      type = concept[0..idx]
      ids = concept[idx+1..-1]
    end

    str = type + self.reorder_concept_id(ids)
    if entity_type.present? && entity_type.prefix.present? 
      str = str.gsub(/\s+/, "")
      re = Regexp.new(Regexp.escape(entity_type.prefix), "i")
      
      str = entity_type.prefix + str unless str =~ re
      str = str.gsub(re, entity_type.prefix)
    end
    str
  end


  def lock
    self.locked = true
    return self.save
  end

  def unlock
    self.locked = false
    return self.save
  end

  def save_all_xml
    # Project.transaction do 
    #   self.documents.each{|d| d.get_xml() }
    # end
  end

  def status
    task = self.tasks.first
    if task.nil?
      self.round_state
    else
      task.status
    end
  end

  def busy?(st = nil)
    if st.nil?
      st = self.status
    end
    self.locked || self.round_begin? || in_task?(st) || self.finalized
  end

  def in_task?(st = nil)
    if st.nil?
      st = self.status
    end
    st == 'requested' || st == 'processing'
  end

  def task_available?(st = nil)
    if st.nil?
      st = self.status
    end
    !self.busy?(st) && self.documents_count > 0
  end
  
  def status_with_icon(st = nil)
    if st.nil?
      st = self.status
    end
    if self.finalized
      "<i class='icon check circle'></i> Final Version".html_safe
    elsif self.in_task?(st)
      "<i class='icon refresh loading'></i> #{st.capitalize}".html_safe
    elsif self.preparing?
      "<i class='icon tasks'></i> #{st.capitalize}".html_safe
    elsif self.annotating?
      "<i class='icon edit outline'></i> #{st.capitalize}".html_safe
    elsif self.reviewing?
      "<i class='icon eye'></i> #{st.capitalize}".html_safe
    end
  end

  def has_annotations?
    !self.annotations.empty?

    # document_ids = self.documents.map{|d| d.id}
    # !Annotation.where("document_id in (?) AND version = ?", document_ids, self.round).empty?

  #   size = documents.size

  #   for i in (0...size)
  #     return true if !documents[i].nil? && documents[i].has_annotations?
  #   end
  #   return false
  end

  def has_annotations_on_done_documents?
    size = documents.size

    for i in (0...size)
      return true if !documents[i].nil? && documents[i].is_done? && documents[i].has_annotations?
    end
    return false
  end

  def entity_type(name) 
    return if name.blank?
    if @etype_map.nil?
      @etype_map = {}
      self.entity_types.each do |t|
        @etype_map[t.name.upcase] = t
      end
    end
    etype =  @etype_map[name.upcase]
    if etype.nil?
      t = self.entity_types.create({name: name});
      @etype_map[name.upcase] = t
      etype = t
    end
    etype
  end

  def has_sample_lexicons?
    self.lexicon_groups.where("`key` = ?", 'samples').present?
  end

  def pre_trained_model?(name)
    return name == "Chemical" || name == "Disease" || name == "Chemical/Disease" ||
           name == "Gene" || name == "Species" || name == "Variation" || name == "All"
  end

  def destroy_all
    Project.transaction do 
      lexicon_groups = self.lexicon_groups.all.map{|l| l.id}
        documents = Document.find_by_sql(["SELECT id FROM documents WHERE project_id = ?", self.id]).map{|l| l.id}

      Project.execute_sql("DELETE FROM lexicons WHERE lexicon_group_id IN (?)", lexicon_groups)
      Project.execute_sql("DELETE FROM lexicon_groups WHERE project_id = ?", self.id)
      Project.execute_sql("DELETE FROM entity_types WHERE project_id = ?", self.id)
      Project.execute_sql("DELETE FROM models WHERE project_id = ?", self.id)
      Project.execute_sql("DELETE FROM project_users WHERE project_id = ?", self.id)
      Project.execute_sql("DELETE FROM relation_types WHERE project_id = ?", self.id)
      Project.execute_sql("DELETE FROM tasks WHERE project_id = ?", self.id)

      Project.execute_sql("DELETE FROM annotations WHERE document_id IN (?)", documents)
      Project.execute_sql("DELETE FROM nodes WHERE document_id IN (?)", documents)
      Project.execute_sql("DELETE FROM relations WHERE document_id IN (?)", documents)
      Project.execute_sql("DELETE FROM assigns WHERE project_id = ?", self.id)
      Project.execute_sql("DELETE FROM documents WHERE project_id = ?", self.id)
      Project.execute_sql("DELETE FROM projects WHERE id = ?", self.id)
    end
  end

  def cancel_round
    if self.round > 0
      Project.transaction do 
        documents = Document.find_by_sql(["SELECT id FROM documents WHERE project_id = ?", self.id]).map{|l| l.id}
        Project.execute_sql("DELETE FROM annotations WHERE version=? AND document_id IN (?)", self.round, documents)
        Project.execute_sql("DELETE FROM nodes WHERE version=? AND document_id IN (?)", self.round, documents)
        Project.execute_sql("DELETE FROM relations WHERE version=? AND document_id IN (?)", self.round, documents)
        Project.execute_sql("UPDATE documents SET version = ?, done_count = 0 WHERE project_id = ?", self.round - 1, self.id)
        Project.execute_sql("UPDATE assigns SET detached = 0, done = 0 WHERE project_id = ?", self.id)
        Project.execute_sql("UPDATE projects SET round = ?, finalized = 0, locked = 0, round_state = 0 WHERE id = ?", self.round - 1, self.id)
        self.collaborates.pop
        self.save
      end
    end
    return true
  end

  def entities_stat(version)
    ret = {}
    self.entity_types.each{|t| ret[t.name] = {total: 0, uniq_str: 0, uniq_ids: 0, no_ids: 0}}
    documents = Document.find_by_sql(["SELECT id FROM documents WHERE project_id = ?", self.id]).map{|l| l.id}

    rows = Annotation.execute_sql("
      SELECT a_type, COUNT(*), COUNT(DISTINCT content) 
      FROM annotations 
      WHERE document_id IN (?) AND version = ?
      GROUP BY a_type
    ", documents, version)
    rows.each do |r|
      next if ret[r[0]].nil?
      ret[r[0]][:total] = r[1]
      ret[r[0]][:uniq_str] = r[2]
    end

    rows = Annotation.execute_sql("
      SELECT a_type, COUNT(DISTINCT concept)
      FROM annotations 
      WHERE document_id IN (?) AND version = ? AND (concept != '' AND concept IS NOT NULL)
      GROUP BY a_type
    ", documents, version)
    rows.each do |r|
      next if ret[r[0]].nil?
      ret[r[0]][:uniq_ids] = r[1] 
    end

    rows = Annotation.execute_sql("
      SELECT a_type, COUNT(*)
      FROM annotations 
      WHERE document_id IN (?) AND version = ? AND (concept = '' OR concept IS NULL)
      GROUP BY a_type
    ", documents, version)
    rows.each do |r|
      next if ret[r[0]].nil?
      ret[r[0]][:no_ids] = r[1] 
    end

    ret
  end

  private
  def txt2bioc(txt, spliter = "\n")
    logger.debug(txt.inspect)
    raise RuntimeError, 'File is not text' unless txt.kind_of? String

    c = SimpleBioC::Collection.new
    d = SimpleBioC::Document.new(c)
    d.id = Time.now.strftime("%y%m%d%H%M%S%L") + ((0..5).map { (65 + rand(9)).chr }.join)
    c.documents << d
    offset = 0
    txt.split(spliter).each do |l|
      next if l.blank?
      p = SimpleBioC::Passage.new(d)
      p.text = l
      p.offset = offset
      offset += l.size
      d.passages << p
    end
    c
  end

  def check_filetype(file)
    logger.debug("************** #{file.inspect} *************")
    if file.respond_to?(:extname)
      file.extname.gsub(".", "")
    elsif file.respond_to?(:content_type)
      file.content_type.split("/")[1]
    else
      "xml"
    end
  end
end
