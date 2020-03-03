class CreateApiKeys < ActiveRecord::Migration[5.2]
  def change
    create_table :api_keys do |t|
      t.string :key
      t.references :user, foreign_key: true
      t.datetime :last_access_at
      t.string :last_access_ip
      t.integer :access_cpount

      t.timestamps
    end
  end
end
