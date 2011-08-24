class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.string :name, :limit => 200
      t.string :address1, :limit => 200
      t.string :address2, :limit => 200
      t.string :street, :limit => 200
      t.string :city, :limit => 200
      t.integer :post_code, :limit => 200
      t.string :country, :limit => 200
      t.integer :phone1, :limit => 200
      t.integer :phone2, :limit => 200
      t.string :fax, :limit => 200
      t.string :status, :limit => 200, :default => 'Active'
      t.timestamps
    end
  end

  def self.down
    drop_table :locations
  end
end
