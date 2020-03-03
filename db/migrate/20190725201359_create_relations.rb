class CreateRelations < ActiveRecord::Migration[5.2]
  def change
    create_table :relations do |t|
      t.string :r_id
      t.string :r_type
      t.references :user, foreign_key: true
      t.string :note, default: ""
      t.text :infons
      t.string :annotator, limit: 10000
      t.references :document, foreign_key: true
      t.references :assign, foreign_key: true
      t.string :passage
      t.integer :r_id_no
      t.integer :version, default: 0

      t.timestamps
    end
  end
end
