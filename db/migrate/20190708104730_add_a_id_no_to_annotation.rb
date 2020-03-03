class AddAIdNoToAnnotation < ActiveRecord::Migration[5.2]
  def change
    add_column :annotations, :a_id_no, :integer
  end
end
