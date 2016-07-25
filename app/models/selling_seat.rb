class SellingSeat < ActiveRecord::Base

  belongs_to :seat
  belongs_to :event
  belongs_to :ticket_type
  belongs_to :color

end
