class CreateAssigns < ActiveRecord::Migration[5.2]
  def change
    create_table :assigns do |t|
      t.references :project, foreign_key: true
      t.references :document, foreign_key: true
      t.references :user, foreign_key: true
      t.integer :round, default: 0
      t.boolean :done, default: false
      t.boolean :curatable, default: false
      t.datetime :begin_at
      t.datetime :end_at
      t.timestamps
    end
  end
end
