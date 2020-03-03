class EntityUtil
  def self.get_annotation_entity(annotation)
    entity_type = annotation.infons["type"] || "" 
    concept = annotation.infons["identifier"] || ""
    annotator = annotation.infons["annotator"] || ""
    updated_at = annotation.infons["updated_at"] || ""
    return {type: entity_type, id: concept, annotator: annotator, updated_at: updated_at}  
    # return {type: "", id: ""} if entity_type.nil?

    # c = annotation.infons[entity_type + "ID"]
    # return {type: entity_type, id: c} unless c.nil?

    # annotation.infons.each do |k, v|
    #   if k.include?("ID") || k.include?("Id")
    #     return {type: entity_type, id: v}
    #   end 
    # end
    # {type: entity_type, id: ""}
  end

  def self.update_annotation_entity(annotator, annotation, type, concept, note = "", no_update_note = false) 
    annotation.infons["annotator"] = annotator if annotator.present?
    annotation.infons["updated_at"] = Time.now.utc.iso8601
    annotation.infons["type"] = type if type.present?
    annotation.infons["identifier"] = concept if concept.present?
    if note.present?
      annotation.infons["note"] = note 
    elsif !no_update_note
      annotation.infons.delete('note')
    end
    # unless annotation.infons[type + "ID"].nil?
    #   annotation.infons[type + "ID"] = concept
    #   return
    # end
    # annotation.infons.each do |k, v|
    #   if k.include?("ID") || k.include?("Id")
    #     annotation.infons[k] = concept
    #   end 
    # end      
  end
end