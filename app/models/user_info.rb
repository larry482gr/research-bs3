class UserInfo < ActiveRecord::Base
  belongs_to :user, touch: true
  has_one :language
  
  include Tokenable

  private

  def get_proper_language
    language = [(t :english), (t :greek)]
    case self.language
      when 1
        lang = language[1]
      when 2
        lang = language[2]
    end

    return lang
  end
end
