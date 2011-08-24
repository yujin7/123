class CreatePackageServices < ActiveRecord::Migration
  def self.up
    create_table :package_services do |t|
      t.integer :package_id
      t.integer :service_id
      t.timestamps
    end
  end

  def self.down
    drop_table :package_services
  end
end
