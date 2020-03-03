class AddEnableAuditToProject < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :enable_audit, :boolean, default: false
  end
end
