class Event < ActiveRecord::Base
  belongs_to :competition
  has_many :ticket_items
  has_many :selected_places
  has_many :bron_tickets
  has_many :entrances
  has_many :selling_seats
  has_many :invoices
  has_many :intervals
  attr_reader :name_and_date

  def display_name
    self.name_and_date # or whatever column you want
  end



  def name_and_date
    self.name + ' (' + self.datetime.to_s(:short) + ')'
  end
end
