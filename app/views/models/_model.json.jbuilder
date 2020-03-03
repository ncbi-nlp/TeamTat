json.extract! model, :id, :url, :user_id, :name, :created_at, :updated_at
json.url model_url(model, format: :json)