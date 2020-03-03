class Model < ApplicationRecord
  belongs_to :project, counter_cache: true
  validates :name, presence: true
  has_many :task, dependent: :nullify
  
  def option_item
    ["[User] #{self.name} (created at #{self.created_at})", self.id]
  end

  def model_url
    "https://www.ncbi.nlm.nih.gov/CBBresearch/Lu/Demo/RESTful/eztag.cgi/ezTag_P#{'%016X' % self.project.id}_#{self.url}"
  end
  def status
    if self.url.blank?
      "Processing"
    else
      "Done"
    end
  end
end
