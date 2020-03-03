class EntityType < ApplicationRecord
  belongs_to :project, counter_cache: true
  before_validation :normalize_name
  before_save :adjust_color
  validates :name, uniqueness: { scope: :project, message: "- The type already exists in the project" }
  validates :name, presence: { message: "- Invalid entity type"}
  COLORS = %w(#CCFFFF #CCFFCC #FFFF99 #FFCCCC #66CCFF #99FF66 #FFCC00 #CCFF66 #FF66FF #FF9999 #99CC00 #00CC99 #00CCFF #9966FF #CCCC00 #FF9933)

  DEFAULT_COLORMAP = {
    "chemical"  => "#FFEA00",
    "other"     => "#C2D1E5",
    "species"   => "#B2B6FF",
    "gene"      => "#99FF66",
    "stargene"  => "#00CCFF",
    "generif"   => "#88B500",
    "disease"   => "#FF9999",
    "mutation"   => "#B9EDFF"
  }
  DEFAULT_NAMEMAP = {
    "chemical"  => "Chemical",
    "other"     => "Other",
    "species"   => "Species",
    "gene"      => "Gene",
    "stargene"  => "StarGene",
    "generif"   => "GeneRif",
    "disease"   => "Disease",
    "mutation"   => "Mutation"
  }
  def font_color
    a = ( self.color.match /(..?)(..?)(..?)/ )[1..3]
    a.map!{ |x| x + x } if self.color.size == 3

    r = a[0].hex
    g = a[1].hex
    b = a[2].hex
    g = (r + g + b) / 3.0
    if g > 128
      return "000"
    else
      return "FFF"
    end
  end

  def normalize_name
    self.name = self.name.strip.tr(" \t\r\n", '_').gsub(/[ !@#$%^&*() +\-=\[\]{};':"\\|,.<>\/?]/i, '')
    if self.prefix.present? 
      self.prefix = self.prefix.strip.upcase
      if self.prefix[-1] != ":"
        self.prefix = self.prefix.concat(":")
      end
    end
  end

  def adjust_color
    if self.color.blank?
      name = self.name.strip.downcase
      self.color = DEFAULT_COLORMAP[name]
      self.color = EntityType.random_color if self.color.blank?
    end
  end

  def self.random_color
    while true
      r = rand(256)
      g = rand(256)
      b = rand(256)
      gray = (r + g + b).to_f / 3.0
      break if gray > 160 && gray < 220
    end
    "##{"%02X" % r}#{"%02X" % g}#{"%02X" % b}"
  end
end
