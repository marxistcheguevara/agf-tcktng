class Competition < ActiveRecord::Base
  translates :name, :program
  has_many :events
end
