class AddSig1Sig2ToRelation < ActiveRecord::Migration[5.2]
  def change
    change_column :annotations, :annotator, :string, limit: 3000
    change_column :relations, :annotator, :string, limit: 3000
    add_column :relations, :sig1, :string, limit: 5000
    add_column :relations, :sig2, :string, limit: 5000

    Relation.all.each do |r|
      r.update_signature
    end
  end
end
