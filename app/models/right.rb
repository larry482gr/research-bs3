class Right < ActiveRecord::Base
  validates_uniqueness_of :label
  has_and_belongs_to_many :profiles

  def list_users?
    @current_user.profile.rights
  end
end
