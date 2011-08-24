class GuestsTableChanges < ActiveRecord::Migration
  def self.up
    remove_column :guests, :preferred_spa_location
    remove_column :guests, :preferred_staff
    remove_column :guests,:membership_type
    remove_column :guests, :service_package
    add_column :guests, :location_id, :integer
    add_column :guests, :employee_id, :integer
    add_column :guests, :membership_id, :integer
  end

  def self.down
    remove_column :guests, :location_id
    remove_column :guests, :employee_id
    remove_column :guests, :membership_id
    add_column :guests, :preferred_spa_location, :string
    add_column :guests, :preferred_staff, :string, :limit => 40
    add_column :guests, :membership_type, :string, :limit => 20
    add_column :guests, :service_package, :string, :limit => 20
  end
end
