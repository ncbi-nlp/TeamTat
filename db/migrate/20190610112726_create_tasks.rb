class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.references :user, foreign_key: true
      t.references :project, foreign_key: true
      t.string :tagger
      t.integer :task_type
      t.string :pre_trained_model
      t.string :status
      t.string :tool_begin_at
      t.string :tool_end_at
      t.string :canceled_at
      t.references :model, foreign_key: true
      t.references :lexicon_group, foreign_key: true
      t.boolean :has_model, default: false
      t.boolean :has_lexicon_group, default: false

      t.timestamps
    end
  end
end
