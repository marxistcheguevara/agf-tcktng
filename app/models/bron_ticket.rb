class BronTicket < ActiveRecord::Base
  belongs_to :event
  belongs_to :cashier
  belongs_to :seat
end
