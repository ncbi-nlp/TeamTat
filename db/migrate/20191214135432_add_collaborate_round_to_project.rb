class AddCollaborateRoundToProject < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :collaborate_round, :boolean, default: false
  end
end
