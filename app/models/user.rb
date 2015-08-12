require 'digest/sha1'

class User < ActiveRecord::Base
  has_one :user_info
  has_one :language, through: :user_info
  belongs_to :profile

  has_and_belongs_to_many :projects
  belongs_to :project_profile
  has_many :project_files

  has_many :invitations, :source => :email, :foreign_key => :email

  has_many :history_user_infos
  has_many :history_projects

  accepts_nested_attributes_for :user_info

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :username, presence: true, uniqueness: true, length: { in: 6..20 }
  validates :password, presence: true , length: { in: 8..50 }
  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: true,
                    length: { maximum: 50 }

  def owner?
    profile.label == Profile::OWNER
  end

  def admin?
    profile.label == Profile::ADMIN
  end

  def can_access?(right_label)
    can_access = false
    profile.rights.each do |right|
      can_access = true if right.label == right_label
    end
    return can_access
  end

  protected

  before_create {|user| user.password = Digest::SHA1.hexdigest(user.password)}
  before_validation :set_default_profile

  def set_default_profile
    if User.count.zero?
      self.profile ||= Profile.find_by_label(Profile::OWNER)
    else
      self.profile ||= Profile.find_by_label(Profile::USER)
    end
  end
end