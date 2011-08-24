class Location < ActiveRecord::Base
  require 'country_select'
  validates :name, :address1,  :street, :city, :post_code, :phone1, :location_email_id, :code_number,  :presence => true, :length => { :maximum => 200 }
  validates :address2, :phone2, :fax, :length => { :maximum => 200 }
  validates :name, :location_email_id, :code_number, :uniqueness => true
  validates_format_of :location_email_id, :with => RE_EMAIL_OK
  #  validates_format_of :name,   :with => /[a-zA-Z]/, :on => :create, :message => 'Name no special characters allowed'
  define_index do
    indexes name, :sortable => true
    indexes city, :sortable => true
    indexes country, :sortable => true
    indexes status, :sortable => true
  end

  has_many :equipments, :foreign_key => 'location_id'
  has_many :rooms, :foreign_key => 'location_id'
  has_many :employee_locations
  has_many :employees , :through => :employee_locations
  has_many :guests
  has_many :location_operation_hours, :dependent => :destroy
  has_many :location_closed_dates, :dependent => :destroy
  has_many :users
  has_many :location_equipments, :dependent => :destroy
  has_many :equipments, :through => :location_equipments

  has_many :locations_products, :dependent => :destroy
  has_many :products, :through => :locations_products
end
