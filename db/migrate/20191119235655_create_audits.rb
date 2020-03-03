class CreateAudits < ActiveRecord::Migration[5.2]
  def change
    create_table :audits do |t|
      t.references :user, foreign_key: true
      t.references :project, foreign_key: true
      t.references :document, foreign_key: true
      t.references :annotation, foreign_key: true
      t.references :relation, foreign_key: true
      t.string :message

      t.timestamps
    end
  end
end
