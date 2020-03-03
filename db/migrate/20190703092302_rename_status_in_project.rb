class RenameStatusInProject < ActiveRecord::Migration[5.2]
  def change
    rename_column :projects, :status, :round_state
  end
end
