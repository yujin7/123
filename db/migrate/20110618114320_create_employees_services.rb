class CreateEmployeesServices < ActiveRecord::Migration
  def self.up
    create_table :employees_services do |t|
      t.integer :employee_id
      t.integer :service_id
    end
  end

  def self.down
    drop_table :employees_services
  end
end
