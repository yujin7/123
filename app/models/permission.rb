class Permission < ActiveRecord::Base
  has_many :permission_roles , :dependent => :destroy
  has_many :roles , :through => :permission_roles , :dependent => :destroy
  validates :name, :presence => true
end
