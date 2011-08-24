class LocationClosedDate < ActiveRecord::Base
  belongs_to :location
  validates :closed_date, :location_id, :description , :presence => true
end
