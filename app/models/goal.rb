class Goal < ActiveRecord::Base
  attr_accessible :action, :end, :frequency, :frequency_unit, :quantity, :start, :unit
  has_many :logs, dependent: :destroy

  def log_sum
    logs.inject(0){|sum,x| sum + x.quantity }
  end

  def on_target
    log_sum > Goalie::DateUtil.daily_target(self)
  end
end
