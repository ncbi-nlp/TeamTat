class AddFinalizedToProject < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :finalized, :boolean, default: false
  end
end
