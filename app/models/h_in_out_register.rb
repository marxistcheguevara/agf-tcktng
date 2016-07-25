class HInOutRegister < ActiveRecord::Base
  belongs_to :event
  belongs_to :seat
end
