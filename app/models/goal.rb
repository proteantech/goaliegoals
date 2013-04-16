class Goal < ActiveRecord::Base
  attr_accessible :action, :end, :frequency, :frequency_unit, :quantity, :start, :unit
  has_many :logs, dependent: :destroy
end
