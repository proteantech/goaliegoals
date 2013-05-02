require 'test_helper'

class GoalTest < ActiveSupport::TestCase

  def test_create
    h = {
        :action =>          'Eat',
        :quantity =>        2,
        :unit =>            'vegetables',
        :frequency =>       1,
        :frequency_unit =>  'day',
        :start =>           Date.today,
        :end =>             Date.today >> 1
    }
    Goal.create!(h)
  end

  def test_bad_frequency_unit
    h = {
        :action =>          'Eat',
        :quantity =>        2,
        :unit =>            'vegetables',
        :frequency =>       1,
        :frequency_unit =>  'bad_day',
        :start =>           Date.today,
        :end =>             Date.today >> 1
    }
    assert_raise ActiveRecord::RecordInvalid do
      Goal.create!(h)
    end
  end

  def test_end_date_equal_start
    h = {
        :action =>          'Eat',
        :quantity =>        2,
        :unit =>            'vegetables',
        :frequency =>       1,
        :frequency_unit =>  'day',
        :start =>           Date.today,
        :end =>             Date.today
    }
    Goal.create!(h)
  end

  def test_end_date_before_start
    h = {
        :action =>          'Eat',
        :frequency =>       2,
        :frequency_unit =>  'vegetables',
        :quantity =>        1,
        :unit =>            'bad_day',
        :start =>           Date.today,
        :end =>             Date.today << 1
    }
    assert_raise ActiveRecord::RecordInvalid do
      Goal.create!(h)
    end
  end

  def test_todays_minimum
    DateTime.expects(:now).returns(DateTime.new(2013, 4, 3)).at_least(1)
    assert_equal 4, goals(:books_2_per_day).todays_minimum
  end

  def test_length
     assert_equal 60, goals(:books_2_per_month).length
  end

  def test_log_sum_2_books_per_day
    assert_equal 30, goals(:books_2_per_day).log_sum
  end

  def test_pass_minimum_2_books_per_day
    assert_equal 120, goals(:books_2_per_day).pass_minimum
  end

  def test_percent_completed_50
    assert_equal 25, goals(:books_2_per_day).percentage_completed
  end

  def test_days_since_start_15
    DateTime.expects(:now).returns(DateTime.new(2013, 4, 16)).at_least(1)
    assert_equal 15, goals(:books_2_per_month).days_since_start
  end

  def test_days_since_start_2
    DateTime.expects(:now).returns(DateTime.new(2013, 4, 3)).at_least(1)
    assert_equal 2, goals(:books_2_per_month).days_since_start
  end

  def test_todays_percentage_of_time_completed
    DateTime.expects(:now).returns(DateTime.new(2013, 4, 16)).at_least(1)
    assert_equal 25, goals(:books_2_per_month).todays_percentage_of_time_completed
  end

  def test_per_diem_2_books_per_day
    DateTime.expects(:now).returns(DateTime.new(2013, 5, 31)).at_least(0)
    g = goals(:books_2_per_day)
    expected = 2
    assert_equal(expected, g.per_diem)
  end

  def test_todays_minimum_2_books_per_month
    DateTime.expects(:now).returns(DateTime.new(2013, 5, 31)).at_least(0)
    g = goals(:books_2_per_month)
    expected = 8
    assert_equal(expected, g.todays_minimum.round(2))
  end

  def test_todays_minimum_2_books_per_day
    DateTime.expects(:now).returns(DateTime.new(2013, 5, 31)).at_least(0)
    g = goals(:books_2_per_day)
    expected = 120
    assert_equal(expected, g.todays_minimum)
  end

end
