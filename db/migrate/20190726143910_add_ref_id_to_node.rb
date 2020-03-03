class AddRefIdToNode < ActiveRecord::Migration[5.2]
  def change
    add_column :nodes, :ref_id, :string
  end
end
