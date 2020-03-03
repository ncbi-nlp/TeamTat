class AddRequestsToAudit < ActiveRecord::Migration[5.2]
  def change
    add_column :audits, :request, :text
    add_column :audits, :result, :text
  end
end
