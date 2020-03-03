class LexiconGroup < ApplicationRecord
  has_many :lexicons, dependent: :destroy
  has_many :tasks, dependent: :nullify
  validates :name, presence: true
  belongs_to :project, counter_cache: true

  def option_item
    ["#{self.name} (#{self.lexicons_count} items)", self.id]
  end

  def self.load_samples(project)
    LexiconGroup.transaction do 
      lg = project.lexicon_groups.create!({name: 'Sample Lexicon', key: 'samples'})
      File.open(Rails.root.join("public", "sample_lexicon.tsv"), "r") do |f|
        lg.upload_lexicon(f)
      end
    end
  end

  def upload_lexicon(file) 
    LexiconGroup.transaction do 
      self.lexicons.delete_all
      arr = []
      TSV.parse(file.read).without_header.map do |row|
        # logger.debug(row.inspect)
        line = "(#{row[0].dump}, #{row[1].dump}, #{row[2].dump}, #{self.id}, NOW(), NOW())"
        # logger.debug(line)
        arr << line
      end
      sql = "INSERT INTO lexicons(ltype, lexicon_id, name, lexicon_group_id, created_at, updated_at) VALUES " + arr.join(",")
      Lexicon.connection.insert(sql)
      count = Lexicon.where(lexicon_group_id: self.id).count()
      logger.debug(count)
      ActiveRecord::Base.connection.execute("UPDATE lexicon_groups SET lexicons_count = #{count} WHERE id = #{self.id}")
    end
  end
end
