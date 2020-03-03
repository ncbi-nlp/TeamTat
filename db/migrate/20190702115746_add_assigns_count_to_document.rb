class AddAssignsCountToDocument < ActiveRecord::Migration[5.2]
  def change
    add_column :documents, :assigns_count, :integer, default: 0

    execute <<-SQL.squish
        UPDATE documents
           SET 
           assigns_count = (SELECT count(1) FROM assigns WHERE assigns.document_id = documents.id);
        SQL
  end
end
