class CreateProductsServices < ActiveRecord::Migration
  def self.up
    create_table :products_services do |t|
      t.integer :service_id
      t.integer :product_id
      t.string :quantity
      t.integer :product_cost
    end
  end

  def self.down
    drop_table :products_services
  end
end
