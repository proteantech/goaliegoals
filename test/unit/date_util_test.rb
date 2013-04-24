require 'test_helper'
require_relative '../../lib/goalie/date_util'
class DateUtilTest < ActiveSupport::TestCase

  def test_2_books_per_month
    DateTime.expects(:now).returns(DateTime.new(2013, 5, 31))
    g = goals(:books_2_per_month)
    target = Goalie::DateUtil::todays_minimum(g)
    expected = 8
    assert_equal(expected, target)
  end

  def test_2_books_per_day
    DateTime.expects(:now).returns(DateTime.new(2013, 5, 31))
    g = goals(:books_2_per_day)
    target = Goalie::DateUtil::todays_minimum(g)
    expected = 120
    assert_equal(expected, target)
  end
end