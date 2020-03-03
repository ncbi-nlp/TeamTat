class CreateProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
      t.string :name, null: false, default: ""
      t.string :desc
      t.integer :round, default: 0
      t.integer :total_rounds, default: 3
      t.integer :documents_count, default: 0
      t.string :cdate
      t.string :key
      t.string :source
      t.string :xml_url
      t.integer :annotations_count, default: 0
      t.integer :status

      t.timestamps
    end
  end
end
