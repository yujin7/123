class Product < ActiveRecord::Base
  has_attached_file :avatar, :styles => { :medium => "100x100>", :thumb => "100x100>" }

  validates :status, :name, :sales_tax, :presence => true
  validates :category_id, :presence => { :message => "Please slect one category"}
  validates :sub_category_id, :presence => { :message => "Please slect one sub category"}
  validates :name, :uniqueness => true
  validates :sales_tax, :quantity, :numericality => true

  has_many :payment_products, :dependent => :destroy
  has_many :payments, :through => :payment_products
  
  has_many :inventories, :dependent => :destroy
  belongs_to :category, :foreign_key => 'category_id'
  belongs_to :sub_category, :foreign_key => 'sub_category_id'
  belongs_to :product_brand, :foreign_key => 'product_brand_id'

  has_many :products_services, :dependent => :destroy
  has_many :services, :through => :products_services

  has_many :locations_products, :dependent => :destroy
  has_many :locations, :through => :locations_products


  define_index do
    indexes name, :sortable => true
    indexes status, :status => true
    #    indexes location, :sortable => true
  end
end
