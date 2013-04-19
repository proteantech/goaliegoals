require 'test_helper'
require_relative '../../lib/goalie/date_util'
class DateUtilTest < ActiveSupport::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.
  def teardown
    # Do nothing
  end

  # Fake test
  def test_2_books_per_month
    DateTime.expects(:now).returns(DateTime.new(2013, 5, 31))
    g = goals(:books_2_per_month)
    target = Goalie::DateUtil::daily_target(g)
    expected = 8
    assert_equal(expected, target)
  end

  def test_2_books_per_day
    DateTime.expects(:now).returns(DateTime.new(2013, 5, 31))
    g = goals(:books_2_per_day)
    target = Goalie::DateUtil::daily_target(g)
    expected = 120
    assert_equal(expected, target)
  end
end