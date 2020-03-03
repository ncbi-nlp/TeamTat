class AddAgreeToAnnotation < ActiveRecord::Migration[5.2]
  def change
    add_column :annotations, :review_result, :integer, default: 0
    add_column :relations, :review_result, :integer, default: 0
  end
end
