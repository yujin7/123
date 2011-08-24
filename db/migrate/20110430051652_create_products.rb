class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.string :name, :limit => 200
      t.text :description, :limit => 250
      t.string :status, :limit => 200
      t.integer :product_brand_id
      t.integer :category_id
      t.integer :sub_category_id
      t.string  :avatar_file_name
      t.string  :avatar_content_type
      t.integer  :avatar_file_size
      t.string :avatar_updated_at
      t.string :ingredients, :limit => 250
      t.integer :sales_tax, :limit => 3
      t.integer :quantity, :limit => 3
      t.string :online_shop, :limit => 250
      t.timestamps
    end
  end

  def self.down
    drop_table :products
  end
end
