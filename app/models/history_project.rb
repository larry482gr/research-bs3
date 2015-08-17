class HistoryProject < ActiveRecord::Base
  belongs_to :user
  belongs_to :project

  validates :from_value, presence: true
  validates :to_value, presence: true
  validates :change_type, presence: true

  protected

  before_create :check_identical_value

  def check_identical_value
    false unless self.from_value != self.to_value
  end
end