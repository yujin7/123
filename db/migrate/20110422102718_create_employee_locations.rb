class CreateEmployeeLocations < ActiveRecord::Migration
  def self.up
    create_table :employee_locations do |t|
      t.integer :employee_id
      t.integer :location_id
      t.timestamps
    end
  end

  def self.down
    drop_table :employee_locations
  end
end
