class CreateLocationEquipments < ActiveRecord::Migration
  def self.up
    create_table :location_equipments do |t|
      t.integer :location_id
      t.integer :equipment_id
      t.string  :equipment_code_number
      t.boolean :in_service
    end
  end

  def self.down
    drop_table :location_equipments
  end
end
