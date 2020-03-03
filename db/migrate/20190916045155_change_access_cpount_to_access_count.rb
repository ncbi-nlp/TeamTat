class ChangeAccessCpountToAccessCount < ActiveRecord::Migration[5.2]
  def change
    rename_column :api_keys, :access_cpount, :access_count
  end
end
