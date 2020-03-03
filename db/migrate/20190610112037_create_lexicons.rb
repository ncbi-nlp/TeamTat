class CreateLexicons < ActiveRecord::Migration[5.2]
  def change
    create_table :lexicons do |t|
      t.string :ltype
      t.string :lexicon_id
      t.string :name
      t.references :lexicon_group, foreign_key: true

      t.timestamps
    end
  end
end
