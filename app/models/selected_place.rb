class SelectedPlace < ActiveRecord::Base
  belongs_to :cashier
  belongs_to :event
  belongs_to :seat
end
