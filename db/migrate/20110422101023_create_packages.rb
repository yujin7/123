class CreatePackages < ActiveRecord::Migration
  def self.up
    create_table :packages do |t|
      t.float :total_price
      t.string :name
      t.text :description
      t.string :status, :default => 'active'
      t.integer :discount, :default => '0'
      t.string :deposit, :default => 'none'
      t.timestamps
    end
  end

  def self.down
    drop_table :packages
  end
end