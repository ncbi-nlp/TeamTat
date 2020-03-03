class AddAnnotationsCountToAssign < ActiveRecord::Migration[5.2]
  def change
    add_column :assigns, :annotations_count, :integer, default: 0

    execute <<-SQL.squish
        UPDATE assigns
           SET 
           annotations_count = (SELECT count(1) FROM annotations WHERE annotations.assign_id = assigns.id);
        SQL

  end
end
