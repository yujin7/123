class Service < ActiveRecord::Base
  attr_accessible :service_name, :category_id, :sub_category_id, :duration, :staff_recovery_time, :room_recovery_time, :book_online, :rate,:equipment,:special_notes, :status, :service_code, :requires_equipment
  attr_accessor :service_ids, :room_ids, :equipment_ids, :service_id, :employee_id, :room_id, :equipment_id
  belongs_to :category
  belongs_to :sub_category
  has_many :appointments
  has_many :membership_services, :dependent => :destroy
  has_many :memberships , :through => :membership_services

  has_many :package_services, :dependent => :destroy
  has_many :packages, :through => :package_services


  has_many :payment_services, :dependent => :destroy
  has_many :payments, :through => :payment_services

  has_many :room_services, :dependent => :destroy
  has_many :rooms, :through => :room_services

  has_many :employee_services, :dependent => :destroy
  has_many :employees, :through => :employee_services


  has_many :equipments_services, :dependent => :destroy
  has_many :equipments, :through => :equipments_services

  has_many :products_services, :dependent => :destroy
  has_many :products, :through => :products_services
  
  define_index do
    indexes service_name, :sortable => true
    indexes duration, :sortable => true
    indexes rate, :sortable => true
    indexes status, :sortable => true
  end

  

  validates :service_name, :category_id, :sub_category_id, :duration, :book_online, :status, :service_code , :presence => true
  validates_length_of :service_name, :maximum => 200
  validates_length_of :rate, :maximum => 10
  validates_length_of :special_notes, :maximum => 250, :allow_blank => true
  validates_numericality_of :rate
end
