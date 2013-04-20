require 'test_helper'

class GoalTest < ActiveSupport::TestCase
  def test_length
     assert_equal 60, goals(:books_2_per_month).length
  end

  def test_days_since_start
    DateTime.expects(:now).returns(DateTime.new(2013, 4, 15)).at_least(1)
    assert_equal 14, goals(:books_2_per_month).days_since_start
  end

  def test_todays_percentage_of_time_completed
    DateTime.expects(:now).returns(DateTime.new(2013, 4, 16)).at_least(1)
    assert_equal 25, goals(:books_2_per_month).todays_percentage_of_time_completed
  end

  def test_2_books_per_month
    DateTime.expects(:now).returns(DateTime.new(2013, 5, 31)).at_least(0)
    g = goals(:books_2_per_month)
    target = Goalie::DateUtil::daily_target(g)
    expected = 8
    assert_equal(expected, target)
  end

  def test_2_books_per_day
    DateTime.expects(:now).returns(DateTime.new(2013, 5, 31)).at_least(0)
    g = goals(:books_2_per_day)
    target = Goalie::DateUtil::daily_target(g)
    expected = 120
    assert_equal(expected, target)
  end

end
