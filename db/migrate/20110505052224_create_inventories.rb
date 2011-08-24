class CreateInventories < ActiveRecord::Migration
  def self.up
    create_table :inventories do |t|
      t.integer :product_id
      t.string :name
      t.integer :barcode
      t.text :description
      t.integer :retail_price
      t.integer :cost_price
      t.integer :stock_balance
      t.integer :balance_alert
      t.string :status
    end
  end

  def self.down
    drop_table :inventories
  end
end
