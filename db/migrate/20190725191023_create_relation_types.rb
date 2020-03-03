class CreateRelationTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :relation_types do |t|
      t.string :name
      t.string :color
      t.integer :num_nodes, default: 2
      t.string :entity_type
      t.references :project, foreign_key: true

      t.timestamps
    end

    add_column :projects, :relation_types_count, :integer, default: 0
  end
end
