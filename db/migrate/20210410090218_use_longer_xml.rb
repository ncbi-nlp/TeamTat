class UseLongerXml < ActiveRecord::Migration[5.2]
  def change
    change_column :documents, :xml, :longtext
  end
end
