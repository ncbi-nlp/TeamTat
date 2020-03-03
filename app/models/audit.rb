class Audit < ApplicationRecord
  belongs_to :user
  belongs_to :project
  belongs_to :document, optional: true
  belongs_to :annotation, optional: true
  belongs_to :relation, optional: true
end
