class ServicesTableChanges < ActiveRecord::Migration
  def self.up
    add_column :services, :service_code, :string
    change_column :services, :book_online, :boolean
    remove_column :services, :equipment
    add_column :services, :requires_equipment, :boolean
  end

  def self.down
    remove_column :services, :service_code
    change_column :services, :book_online, :string
    add_column :services, :equipment, :string
    remove_column :services, :requires_equipment
  end
end
