class RelationType < ApplicationRecord
  belongs_to :project, counter_cache: true
  before_validation :normalize_name
  before_save :adjust_color
  validates :name, uniqueness: { scope: :project, message: "- The type already exists in the project" }
  validates :name, presence: { message: "- Invalid relation type"}

  def normalize_name
    self.name = self.name.strip.tr(" \t\r\n", '_').gsub(/[ !@#$%^&*() +\-=\[\]{};':"\\|,.<>\/?]/i, '')
  end

  def adjust_color
    if self.color.blank?
      name = self.name.strip.downcase
      self.color = EntityType::DEFAULT_COLORMAP[name]
      self.color = RelationType.random_color if self.color.blank?
    end
  end

  def entity_types
    if self.entity_type.present?
      entity_type.split(',')
    else
      []
    end
  end

  def font_color
    a = ( self.color.match /(..?)(..?)(..?)/ )[1..3]
    a.map!{ |x| x + x } if self.color.size == 3

    r = a[0].hex
    g = a[1].hex
    b = a[2].hex
    g = (r + g + b) / 3.0
    Rails.logger.debug("== HEX #{self.color} r#{r} g#{g} b#{b} g#{g} =============")
    if g > 128
      return "000"
    else
      return "FFF"
    end
  end
  
  def self.random_color
    while true
      r = rand(256)
      g = rand(256)
      b = rand(256)
      gray = (r + g + b).to_f / 3.0
      break if gray < 150
    end
    "##{"%02X" % r}#{"%02X" % g}#{"%02X" % b}"
  end
end
