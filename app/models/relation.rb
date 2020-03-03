class Relation < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :document
  belongs_to :assign, optional: true
  serialize :infons
  has_many :nodes, -> { order 'order_no asc' }, dependent: :destroy
  enum review_result: [:not_determined, :agreed, :disagreed, :skipped]

  def annotators
    self.annotatoself.split(',')
  end

  def add_annotator(email)
    return if self.annotators.include?(email)
    self.annotator += ",#{email}"
  end

  def adjust_passage
    p = nil
    self.nodes.each do |n|
      a = self.document.annotations.where("a_id = ?", n.ref_id).first
      if a.present? && p.nil?
        p = a.passage
      elsif a.present? && p != a.passage
        p = "document"
        break
      end
    end
    self.passage = p
    self.save
  end

  def ref_in?(ids)
    a = self.nodes.map{|n| n.ref_id}.uniq
    (a - ids).empty?
  end

  def self.r_id_to_num(r_id)
    ret = r_id.match(/R{0,1}([\d]+)/)
    if ret.nil?
      return -1
    else
      ret[1].to_i
    end
  end

  def find_relation_sig(annotations, relations, stack)
    return "E" if stack.include?(self.r_id)
    keys = self.nodes.map do |n|
      a = annotations[n.ref_id]
      if a.present?
         {key: "a(#{a.concept}|#{a.a_type})", role: n.role}
      else
        r = relations[n.ref_id]
        if r.nil?
          return "-"
        else
          stack << self.r_id
          return {key: r.find_relation_key(annotations, relations, stack), role: n.role}
        end
      end
    end
    keys = keys.sort do |a, b| 
      if a[:role] == b[:role]
        return a[:key] <=> b[:key]
      else
        return a[:role] <=> b[:role]
      end
    end
    "r(#{keys.join("-")})"
  end

  def update_signature
    self.sig1 = self.nodes.map{|n| "#{n.ref_id}:#{n.role}"}.join("|")
    self.sig2 = self.nodes.map{|n| "#{n.ref_id}"}.sort.join("|")
    self.save
  end
end
