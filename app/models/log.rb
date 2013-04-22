class Log < ActiveRecord::Base
  attr_accessible :description, :log_date, :quantity
  belongs_to :goal
  validates :goal, presence: true
  validates_presence_of :log_date
  validates_numericality_of :quantity
end
