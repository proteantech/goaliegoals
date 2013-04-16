class Goal < ActiveRecord::Base
  attr_accessible :action, :end, :frequency, :frequency_unit, :quantity, :start, :unit
end
