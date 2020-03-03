json.id relation.r_id
json.type relation.r_type
json.passage relation.passage
json.note relation.note

json.nodes(relation.nodes) do |n|
  json.ref_id n.ref_id
  json.role n.role
  json.order_no n.order_no
end

json.annotator relation.annotator
json.updated_at relation.updated_at.utc.iso8601
json.user_id relation.user_id
json.relation_id relation.id
