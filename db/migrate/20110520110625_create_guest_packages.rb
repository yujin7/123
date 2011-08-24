class CreateGuestPackages < ActiveRecord::Migration
  def self.up
    create_table :guest_packages do |t|
      t.integer :guest_id
      t.integer :package_id
      t.timestamps
    end
  end

  def self.down
    drop_table :guest_packages
  end
end
