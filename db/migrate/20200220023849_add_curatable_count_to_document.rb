class AddCuratableCountToDocument < ActiveRecord::Migration[5.2]
  def change
    add_column :documents, :curatable_count, :integer, default: 0
    Document.all.each do |d|
      d.update_curatable_count
    end
  end
end
