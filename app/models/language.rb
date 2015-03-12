class Language < ActiveRecord::Base
  belongs_to :user_info

  def option_label
    I18n.t(language).capitalize
  end
end
