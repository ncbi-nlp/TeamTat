class Annotation < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :document
  belongs_to :assign, optional: true
  belongs_to :project, optional: true
  serialize :infons
  enum review_result: [:not_determined, :agreed, :disagreed, :skipped, :final_result]

  def normalize_concept_id
    self.concept = self.document.project.normalize_concept_id(self.concept, self.a_type)
    self.save
  end

  def annotators
    self.annotator.split(',')
  end

  def add_annotator(email)
    return if self.annotators.include?(email)
    self.annotator += ",#{email}"
  end

  def passage_id
    "#passage-#{self.passage}"
  end

  def ptext_id
    "#ptext-#{self.passage}"
  end

  def init_review_result
    ret = Annotation.execute_sql("
        SELECT COUNT(*) FROM annotations
        WHERE document_id = ? AND version = ? and offset=? and content=? and a_type=? and concept=?
      ", self.document_id, self.version, self.offset, self.content, self.a_type, self.concept)

    if ret.first[0] == self.document.assigns.size
      return "agreed"
    else
      return "not_determined"
    end
  end

  def compute_review_result(assign)
    s_pos = self.offset
    e_pos = s_pos + self.content.size
    a_in_range = []
    concepts = []
    contents = []
    entity_types = []
    annotations = self.document.annotations.where('version = ?', self.version)
    annotations = annotations.where('assign_id = ?', assign.id) if assign.present?
    annotations.each do |a|
      ss = a.offset
      ee = a.content.size + ss
      if ee > s_pos && e_pos > ss
        concepts << a.concept
        entity_types << a.a_type
        contents << a.content
        a_in_range << a
      end
      concepts = concepts.uniq
      entity_types = entity_types.uniq
      contents = contents.uniq
    end
    if concepts.size > 1 || entity_types.size > 1 || contents.size > 1
      a_in_range.each do |a| 
        a.review_result = "disagreed"
        a.save
      end
    end
  end
end
