class LocationsProduct < ActiveRecord::Base
  belongs_to :product
  belongs_to :location
end
