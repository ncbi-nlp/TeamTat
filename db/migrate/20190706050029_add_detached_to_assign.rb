class AddDetachedToAssign < ActiveRecord::Migration[5.2]
  def change
    add_column :assigns, :detached, :boolean, default: false
  end
end
