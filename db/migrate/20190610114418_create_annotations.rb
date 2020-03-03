class CreateAnnotations < ActiveRecord::Migration[5.2]
  def change
    create_table :annotations do |t|
      t.string :a_id
      t.string :a_type
      t.string :concept
      t.references :user, foreign_key: true
      t.string :content
      t.string :note
      t.integer :offset, default: 0
      t.string :passage
      t.references :assign, foreign_key: true
      t.integer :source

      t.timestamps
    end
  end
end
