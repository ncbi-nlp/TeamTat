class ChangeTypeForLExiconName < ActiveRecord::Migration[5.2]
  def change
    change_column :lexicons, :name, :text
  end
end
