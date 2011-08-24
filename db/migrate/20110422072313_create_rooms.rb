class CreateRooms < ActiveRecord::Migration
  def self.up
    create_table :rooms do |t|
      t.integer :location_id
      t.string :name, :limit => 200
      t.integer :capacity, :limit => 3
      t.string :description, :limit => 250
      t.string :status, :limit => 200, :default => 'Active'
      t.timestamps
    end
  end

  def self.down
    drop_table :rooms
  end
end
