class CreateLexiconGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :lexicon_groups do |t|
      t.string :name, null: false, default: ""
      t.references :project, foreign_key: true
      t.string :key
      t.integer :lexicons_count, default: 0

      t.timestamps
    end
  end
end
