class CreateNodes < ActiveRecord::Migration[5.2]
  def change
    create_table :nodes do |t|
      t.references :relation, foreign_key: true
      t.integer :order_no
      t.string :role

      t.timestamps
    end
  end
end
