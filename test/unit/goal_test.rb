require 'test_helper'

class GoalTest < ActiveSupport::TestCase

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
