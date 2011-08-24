class AddCodeNumberToEquipments < ActiveRecord::Migration
  def self.up
    add_column :equipments, :code_number, :string, :limit => 30
  end

  def self.down
    remove_column :equipments, :code_number
  end
end
