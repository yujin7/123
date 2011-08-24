class AddPrimaryLocationIdToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :primary_location_id, :integer
  end

  def self.down
    remove_column :users, :primary_location_id
  end
end
