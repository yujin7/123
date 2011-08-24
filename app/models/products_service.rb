class ProductsService < ActiveRecord::Base
  belongs_to :service, :foreign_key => 'service_id'
  belongs_to :product, :foreign_key => 'product_id'
end
