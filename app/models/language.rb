class Language < ActiveRecord::Base
  has_many :users, through: :user_infos

  def option_label
    I18n.t(language).capitalize
  end
end
