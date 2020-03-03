class DeleteTotalRoundFromProject < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :entity_types_count, :integer, default: 0
    add_column :projects, :project_users_count, :integer, default: 0
    add_column :projects, :assigns_count, :integer, default: 0
    remove_column :projects, :total_rounds
    remove_index :annotations, [:document_id, :round, :assign_id]
    add_index :annotations, [:document_id, :user_id]
    remove_column :annotations, :round
    remove_column :assigns, :round
    remove_column :documents, :round

    execute <<-SQL.squish
        UPDATE projects
           SET 
           entity_types_count = (SELECT count(1) FROM entity_types WHERE entity_types.project_id = projects.id),
           project_users_count = (SELECT count(1) FROM project_users WHERE project_users.project_id = projects.id),
           assigns_count = (SELECT count(1) FROM assigns WHERE assigns.project_id = projects.id);
        SQL
  end
end
