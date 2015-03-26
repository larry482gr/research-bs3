class ProjectFile < ActiveRecord::Base
  belongs_to :project, touch: true
  belongs_to :user

  include TimeElapsed

  def owner?(user_id)
    return user_id == self.user_id
  end
end
