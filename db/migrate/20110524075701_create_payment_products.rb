class CreatePaymentProducts < ActiveRecord::Migration
  def self.up
    create_table :payment_products do |t|
      t.integer :payment_id
      t.integer :product_id
      t.timestamps
    end
  end

  def self.down
    drop_table :payment_products
  end
end
