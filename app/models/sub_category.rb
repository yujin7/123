class SubCategory < ActiveRecord::Base
  attr_accessible :name, :category_id
  validates :name, :category_id , :presence => true
  belongs_to :category
  has_many :products, :dependent => :destroy
  has_many :services, :dependent => :destroy
end
