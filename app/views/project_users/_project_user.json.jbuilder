json.extract! project_user, :id, :project_id, :user_id, :role, :created_at, :updated_at
json.url project_user_url(project_user, format: :json)
