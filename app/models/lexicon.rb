class Lexicon < ApplicationRecord
  belongs_to :lexicon_group, counter_cache: true
  validates :name, presence: true

  def self.to_csv(lexicons)
    lexicons.map do |l|
      "#{l.ltype}\t#{l.lexicon_id}\t#{l.name}"
    end.join("\n")
  end

end
