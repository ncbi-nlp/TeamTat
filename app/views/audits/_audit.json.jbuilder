json.extract! audit, :id, :user_id, :project_id, :document_id, :annotation_id, :relation_id, :message, :created_at, :updated_at
json.url audit_url(audit, format: :json)
