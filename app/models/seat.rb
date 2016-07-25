class Seat < ActiveRecord::Base
  has_many :selected_places
  has_many :ticket_items
  has_many :bron_tickets
  has_many :selling_seats

  belongs_to :sector


  def display_name
    self.real_row + self.real_column # or whatever column you want
  end
end
