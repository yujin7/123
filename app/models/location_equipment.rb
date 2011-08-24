class LocationEquipment < ActiveRecord::Base
  belongs_to :equipment
  belongs_to :location
end
