class Log < ActiveRecord::Base
  attr_accessible :description, :log_date, :quantity
  belongs_to :goal
  validates :goal, presence: true
end
