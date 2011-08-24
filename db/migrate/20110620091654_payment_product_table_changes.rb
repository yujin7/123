class PaymentProductTableChanges < ActiveRecord::Migration
  def self.up
    add_column :payments, :cash_card_number, :string
    add_column :payment_products, :quantity, :string
    add_column :payment_products, :product_cost, :integer
  end

  def self.down
    remove_column :payments, :cash_card_number
    remove_column :payment_products, :quantity
    remove_column :payment_products, :product_cost
  end
end
