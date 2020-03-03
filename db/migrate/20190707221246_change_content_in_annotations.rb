class ChangeContentInAnnotations < ActiveRecord::Migration[5.2]
  def change
    change_column :annotations, :content, :text
    add_column :annotations, :passage_id, :string
  end
end
