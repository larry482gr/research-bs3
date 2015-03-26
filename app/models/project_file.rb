class ProjectFile < ActiveRecord::Base
  belongs_to :project, touch: true
  belongs_to :user

  include TimeElapsed

  before_create :set_extension

  def owner?(user_id)
    return user_id == self.user_id
  end

  private

  def set_extension
    if self.extension.nil?
      self.extension = self.filepath.to_s[self.filepath.to_s.rindex('.')..self.filepath.to_s.length-1]
    end
  end
end
