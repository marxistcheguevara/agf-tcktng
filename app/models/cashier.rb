class Cashier < ActiveRecord::Base
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :ticket_items
  has_many :invoices
  has_many :cashier_logs
  has_many :selected_places
  has_many :intervals
  has_many :bron_tickets

  def display_name
    self.email # or whatever column you want
  end

end
