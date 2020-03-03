class CreateDocuments < ActiveRecord::Migration[5.2]
  def change
    create_table :documents do |t|
      t.references :project, foreign_key: true
      t.string :did
      t.datetime :user_updated_at
      t.datetime :tool_updated_at
      t.text :xml
      t.text :title
      t.string :key
      t.integer :did_no
      t.integer :batch_id
      t.integer :batch_no
      t.integer :order_no

      t.timestamps
    end
  end
end
