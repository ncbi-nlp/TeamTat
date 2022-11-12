class ChangeDidToBigInt < ActiveRecord::Migration[5.2]
  def change
    change_column :documents, :did_no, :bigint
    change_column :documents, :batch_id, :bigint
    change_column :documents, :batch_no, :bigint
  end
end
