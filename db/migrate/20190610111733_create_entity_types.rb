class CreateEntityTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :entity_types do |t|
      t.references :project, foreign_key: true
      t.string :name, null: false, default: ""
      t.string :color

      t.timestamps
    end
  end
end
