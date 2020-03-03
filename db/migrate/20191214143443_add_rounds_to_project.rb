class AddRoundsToProject < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :collaborates, :text

    Project.all.each do |p|
      p.collaborates = [false] * (p.round + 1)
      p.save
    end
  end
end
