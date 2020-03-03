class AddVersionToAnnotation < ActiveRecord::Migration[5.2]
  def change
    add_column :annotations, :version, :integer, default: 0
    add_column :documents, :version, :integer, default: 0
    add_column :documents, :xml_at, :datetime

    remove_column :annotations, :passage_id
    remove_column :annotations, :update_time
    remove_column :annotations, :change_type
  end
end
