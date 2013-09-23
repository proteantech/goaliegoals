class Goal < ActiveRecord::Base

  # Need these two to use ApplicationHelper#goalie_number
  include ActionView::Helpers
  include ApplicationHelper

  attr_accessible :action, :end, :frequency, :frequency_unit, :quantity, :start, :unit
  has_many :logs, dependent: :destroy
  belongs_to :user

  validates_presence_of :action, :end, :frequency_unit, :start, :unit
  validates_numericality_of :frequency, :quantity

  validates :frequency_unit,
            :inclusion => { :in => Goalie::DateUtil::TIME_UNITS,
                                   :message => "%{value} is not a Frequency Unit. It should be one of the following: #{Goalie::DateUtil::TIME_UNITS}" }

  validate :end_is_after_start

  def end_is_after_start
    if self.end && start && (self.end < start)
      errors.add(:end, 'end date must be after or equal to start date')
    end
  end

  def to_s
    "#{action} #{goalie_number(quantity)} #{unit} #{goalie_number(frequency)} times a #{frequency_unit} starting #{start} and ending #{self.end}"
  end

  def todays_minimum
    target = (days_since_start * per_diem).round(2)
  end

  def per_diem
    return 0 if !quantity || quantity == 0
    freq_unit_days = Goalie::DateUtil::UNIT_TO_DAYS[frequency_unit.downcase.to_sym]
    freq_in_days = freq_unit_days / frequency
    per_diem = quantity / freq_in_days
  end

  def log_sum
    logs.inject(0){|sum,x| sum + x.quantity }
  end

  def on_target
    log_sum >= todays_minimum
  end

  def todays_percentage_of_time_completed
    days_since_start / length().to_f * 100
  end

  def percentage_completed_above_minimum
    ret = 0
    pcent = percentage_completed - todays_percentage_of_time_completed
    ret = pcent if pcent > 0
    ret
  end

  def percentage_completed
    pcent = log_sum.to_f / pass_minimum * 100
    pcent = 100 if pcent > 100
    pcent
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
