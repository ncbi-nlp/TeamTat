class MakeAnnotatorLonger < ActiveRecord::Migration[5.2]
  def change
    change_column :annotations, :annotator, :string, :limit => 10000
  end
end
