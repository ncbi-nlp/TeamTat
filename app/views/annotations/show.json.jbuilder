if !@annotation.nil?
  json.annotation do
    json.partial! "annotations/annotation", annotation: @annotation
  end
end
