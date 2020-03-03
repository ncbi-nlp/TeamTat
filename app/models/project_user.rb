class ProjectUser < ApplicationRecord
  belongs_to :project, counter_cache: true
  belongs_to :user
  has_many :assigns, dependent: :destroy
  enum role: [:project_manager, :annotator]
  enum status: [:prepare, :annotate, :review]
end
