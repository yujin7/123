class Role < ActiveRecord::Base
  validates :name, :description,  :presence => true
  #  belongs_to :user
  #  has_one :employee
  has_many :role_users
  has_many :users, :through => :role_users, :dependent => :destroy
  has_many :permission_roles , :dependent => :destroy
  has_many :permissions , :through => :permission_roles, :dependent => :destroy
#  has_many :employee_roles
#  has_many :employees, :through => :employee_roles, :dependent => :destroy

  define_index do
    indexes name, :sortable => true
    indexes description, :sortable => true
    indexes status, :sortable => true
  end

end
