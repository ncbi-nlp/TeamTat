class AddInfonsToDocument < ActiveRecord::Migration[5.2]
  def change
    add_column :documents, :infons, :text
  end
end
