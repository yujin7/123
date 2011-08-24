class PackageServiceTableChanges < ActiveRecord::Migration
  def self.up
    add_column :package_services, :quantity, :integer
  end

  def self.down
    remove_column :package_services, :quantity
  end
end
