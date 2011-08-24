class CreateEquipment < ActiveRecord::Migration
  def self.up
    create_table :equipments do |t|
      t.integer :location_id
      t.string :name, :limit => 200
      t.integer :total_number, :limit => 5
      t.integer :no_out_of_service, :limit => 10
      t.string :description
      t.string :special_notes, :limit => 250
      t.string :status, :limit => 200
      t.timestamps
    end
  end

  def self.down
    drop_table :equipments
  end
end
