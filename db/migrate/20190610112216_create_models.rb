class CreateModels < ActiveRecord::Migration[5.2]
  def change
    create_table :models do |t|
      t.string :url
      t.references :project, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
