class ChangeXmlInDocument < ActiveRecord::Migration[5.2]
  def change
    change_column :documents, :xml, :MEDIUMTEXT
  end
end
