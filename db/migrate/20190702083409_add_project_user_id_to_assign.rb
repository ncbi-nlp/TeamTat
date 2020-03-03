class AddProjectUserIdToAssign < ActiveRecord::Migration[5.2]
  def change
    add_column :assigns, :project_user_id, :bigint
    add_index :assigns, :project_user_id
  end
end
