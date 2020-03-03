class AddLexiconGroupsCountToProject < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :lexicon_groups_count, :integer, default: 0
    add_column :projects, :models_count, :integer, default: 0
    add_column :projects, :tasks_count, :integer, default: 0
  end
end
