class Goal < ActiveRecord::Base
  attr_accessible :action, :end, :frequency, :frequency_unit, :quantity, :start, :unit
  has_many :logs, dependent: :destroy
  belongs_to :user

  validates_presence_of :action, :end, :frequency_unit, :start, :unit
  validates_numericality_of :frequency, :quantity

  def to_s
    "#{action} %<quantity>g #{unit} %<frequency>g times per #{frequency_unit} starting #{start} and ending #{self.end}" % {
        quantity: quantity,
        frequency: frequency
    }

  end

  def daily_target
    target = (days_since_start * per_diem).round(2)
  end

  def per_diem
    freq_unit_days = Goalie::DateUtil::UNIT_TO_DAYS[frequency_unit.downcase.to_sym]
    p "freq_unit_days #{freq_unit_days}"
    freq_in_days = freq_unit_days / frequency
    p "freq_in_days #{freq_in_days}"

    per_diem = quantity / freq_in_days
    p "per_diem #{per_diem}"
    per_diem
  end

  def log_sum
    logs.inject(0){|sum,x| sum + x.quantity }
  end

  def on_target
    log_sum >= daily_target
  end

  def todays_percentage_of_time_completed
    days_since_start / length().to_f * 100
  end

  def percentage_completed_above_minimum
    ret = 0
    p = percentage_completed - todays_percentage_of_time_completed
    ret = p if p > 0
    ret
  end

  def percentage_completed
    log_sum.to_f / pass_minimum * 100
  end

  def todays_minimum
    days_since_start * per_diem
  end

  def pass_minimum
    length() * per_diem
  end

  def days_since_start
    end_date = self.end()
    end_date = DateTime.now unless DateTime.now > self.end()
    (end_date - start).to_i
  end

  def length
    (self.end - start).to_i
  end

end
