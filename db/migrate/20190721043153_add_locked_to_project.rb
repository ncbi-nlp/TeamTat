class AddLockedToProject < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :locked, :boolean, default: false
  end
end
