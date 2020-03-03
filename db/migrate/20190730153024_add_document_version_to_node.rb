class AddDocumentVersionToNode < ActiveRecord::Migration[5.2]
  def change
    add_reference :nodes, :document, foreign_key: true
    add_column :nodes, :version, :integer

    Node.all.each do |n|
      n.version = n.relation.version
      n.document_id = n.relation.document_id
      n.save
    end
  end
end
