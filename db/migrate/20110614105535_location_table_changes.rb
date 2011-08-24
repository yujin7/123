class LocationTableChanges < ActiveRecord::Migration
  def self.up
    add_column :locations, :location_email_id, :string, :limit => 100
    add_column :locations, :code_number, :string, :limit => 30
  end

  def self.down
    remove_column :locations, :location_email_id
    remove_column :locations, :code_number
  end
end
