require 'digest/sha1'

class User < ActiveRecord::Base
  has_one :user_info
  belongs_to :profile
  
  has_one :language, through: :user_info
  
  has_and_belongs_to_many :projects
  has_many :project_files
  
  has_many :history_user_infos
  has_many :history_projects
  has_many :history_reports
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :username, presence: true, uniqueness: true
  validates :password, presence: true #, confirmation: true
  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: true
  
  protected
  
  before_create {|user| user.password = Digest::SHA1.hexdigest(user.password)} 
  
  before_validation :set_default_profile
  
  def set_default_profile
    if User.count.zero?
      self.profile ||= Profile.find_by_label('owner')
    else
      self.profile ||= Profile.find_by_label('user')
    end
  end
  
end