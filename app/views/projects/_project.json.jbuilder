json.extract! project, :id, :name, :desc, :round, :documents_count, :cdate, :key, :source, :xml_url, :annotations_count, :status, :created_at, :updated_at
json.url project_url(project, format: :json)
