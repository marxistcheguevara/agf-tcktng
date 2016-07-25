class Interval < ActiveRecord::Base
  belongs_to :cashier
  belongs_to :event
end
