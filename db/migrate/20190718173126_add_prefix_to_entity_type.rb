class AddPrefixToEntityType < ActiveRecord::Migration[5.2]
  def change
    add_column :entity_types, :prefix, :string
  end
end
