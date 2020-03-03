class AddUpdateTimeToAnnotations < ActiveRecord::Migration[5.2]
  def change
    add_column :annotations, :update_time, :string
  end
end
