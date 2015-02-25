class UserInfo < ActiveRecord::Base
  belongs_to :user, touch: true
  has_one :language
  
  include Tokenable

end
