class EquipmentsService < ActiveRecord::Base
  belongs_to :service, :foreign_key => 'service_id'
  belongs_to :equipment, :foreign_key => 'equipment_id'
end
