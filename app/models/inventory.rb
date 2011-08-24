class Inventory < ActiveRecord::Base
  belongs_to :product, :foreign_key => 'product_id'
  validates :name, :barcode, :description, :retail_price, :cost_price, :stock_balance, :balance_alert, :status, :presence => true
end
