class AppointmentsTableChanges < ActiveRecord::Migration
  def self.up
    add_column :appointments, :room_id, :integer
    add_column :appointments, :employee_id, :integer
  end

  def self.down
    remove_column :appointments, :room_id
    remove_column :appointments, :employee_id
  end
end
