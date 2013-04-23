module Goalie
  class DateUtil
    UNIT_TO_DAYS = {
        day: 1,
        week: 7,
        month: 30,
        year: 365

    }

    TIME_UNITS = ['day', 'week', 'month', 'year']

=begin
    # 2 books 2 times per month
    # freq_unit_days = 30
    # freq_in_days = 30 / 2 = 15 # per 15 days
    # per_diem = 2 / 15 = books per day
    # days_since_start = 60
    # target = 60 * per_diem = 8

    # 2 books 1 times per day
    # freq_unit_days = 1
    # freq_in_days = 1 / 1 = 1 # per 1 days
    # per_diem = 2 / 1 = 2 books per day
    # days_since_start = 60
    # target = 60 * .5 = 120
=end
    def self.daily_target(goal)

      per_diem = per_diem(goal)

      days_since_start = goal.days_since_start
      p "days_since_start #{days_since_start}"
      target = (days_since_start * per_diem).round(2)
    end

    def self.per_diem(goal)
      freq_unit_days = Goalie::DateUtil::UNIT_TO_DAYS[goal.frequency_unit.downcase.to_sym]
      p "freq_unit_days #{freq_unit_days}"
      freq_in_days = freq_unit_days / goal.frequency
      p "freq_in_days #{freq_in_days}"

      per_diem = goal.quantity / freq_in_days
      p "per_diem #{per_diem}"
      per_diem
    end

  end
end