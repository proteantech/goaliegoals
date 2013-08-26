module ApplicationHelper
  def goalie_number(num)
    number_with_precision(num, precision: 2, strip_insignificant_zeros: true)
  end
end
