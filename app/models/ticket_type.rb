class TicketType < ActiveRecord::Base
  has_many :selling_seats
end
