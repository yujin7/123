class RoomService < ActiveRecord::Base
  belongs_to :service, :foreign_key => 'service_id'
  belongs_to :room, :foreign_key => 'room_id'
end
