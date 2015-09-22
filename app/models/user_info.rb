#
# Copyright 2015 Kazantzis Lazaros
#

class UserInfo < ActiveRecord::Base
  belongs_to :user, touch: true
  belongs_to :language

  include Tokenable

  before_update :set_nil_params

  protected

  def set_nil_params
    self.first_name = nil unless self.first_name.to_s.strip.length > 0
    self.last_name  = nil unless self.last_name.to_s.strip.length > 0
  end

end