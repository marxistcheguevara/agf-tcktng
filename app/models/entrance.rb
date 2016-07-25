class Entrance < ActiveRecord::Base
  belongs_to :event
  belongs_to :sector
end
