class Category < ActiveRecord::Base
  attr_accessible :name
  validates :name, :presence => true
  has_many :services, :dependent => :destroy
  has_many :sub_categories, :dependent => :destroy
  has_many :products, :dependent => :destroy
end
