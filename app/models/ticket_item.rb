class TicketItem < ActiveRecord::Base

  belongs_to :event
  belongs_to :cashier
  belongs_to :invoice
  belongs_to :seat



end
