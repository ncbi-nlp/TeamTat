class AddRoundToAnnotation < ActiveRecord::Migration[5.2]
  def change
    add_column :annotations, :document_id, :bigint
    add_column :annotations, :round, :integer, default: 0
    add_column :annotations, :change_type, :integer, default: 0
    rename_column :annotations, :source, :parent_id
    add_column :annotations, :annotator, :string
    add_column :annotations, :infons, :text
    add_column :documents, :round, :integer, default: 0
    add_index :annotations, [:document_id, :round, :assign_id]
    remove_column :projects, :status
    add_column :projects, :status, :integer, default: 0
  end
end
