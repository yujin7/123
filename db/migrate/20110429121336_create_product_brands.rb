class CreateProductBrands < ActiveRecord::Migration
  def self.up
    create_table :product_brands do |t|
      t.string :product_brand
    end
    ProductBrand.create(:product_brand => 'ADI Cosmetics')
    ProductBrand.create(:product_brand => 'Loreal')
    ProductBrand.create(:product_brand => 'Ponds')
  end



  def self.down
    drop_table :product_brands
  end
end

