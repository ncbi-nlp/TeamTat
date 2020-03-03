if !@relation.nil?
  json.relation do
    json.partial! "relations/relation", relation: @relation
  end
end
