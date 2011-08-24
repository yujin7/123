class CreateEmployeeServices < ActiveRecord::Migration
  def self.up
    create_table :employee_services do |t|
      t.integer :employee_id
      t.integer :service_id
      t.timestamps
    end
  end

  def self.down
    drop_table :employee_services
  end
end
