class Invoice < ActiveRecord::Base

  has_many :ticket_items
  belongs_to :cashier
  belongs_to :event

  def display_name
    '#' + self.id.to_s + ' - (' + self.ticket_items.count.to_s + ')' # or whatever column you want
  end
end
