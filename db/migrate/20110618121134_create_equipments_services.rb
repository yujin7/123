class CreateEquipmentsServices < ActiveRecord::Migration
  def self.up
    create_table :equipments_services do |t|
      t.integer :equipment_id
      t.integer :service_id
    end
  end

  def self.down
    drop_table :equipments_services
  end
end
