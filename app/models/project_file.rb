class ProjectFile < ActiveRecord::Base
  belongs_to :project, touch: true
  belongs_to :user
end
