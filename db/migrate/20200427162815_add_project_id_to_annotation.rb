class AddProjectIdToAnnotation < ActiveRecord::Migration[5.2]
  def change
    add_reference :annotations, :project, foreign_key: true

    Annotation.all.each do |a|
      a.project = a.document.project
      a.save
    end
  end
end
