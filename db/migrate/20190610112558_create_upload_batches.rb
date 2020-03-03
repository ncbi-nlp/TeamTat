class CreateUploadBatches < ActiveRecord::Migration[5.2]
  def change
    create_table :upload_batches do |t|

      t.timestamps
    end
  end
end
