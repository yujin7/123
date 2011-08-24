class ProductBrand < ActiveRecord::Base
 has_many :products, :foreign_key => 'product_brand_id'
end
