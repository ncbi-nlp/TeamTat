class AddDoneCountToDocument < ActiveRecord::Migration[5.2]
  def change
    add_column :documents, :done_count, :integer, default: 0
    Document.all.each do |d|
      d.update_done_count
    end
  end
end
