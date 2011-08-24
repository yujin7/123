class Employee < ActiveRecord::Base

  require 'country_select'
  attr_accessor :location_ids, :service_ids
  has_attached_file :avatar,
    :default_url => "/images/default_avatar.jpg",
    :url =>  "/system/employee/:id/:style/:basename.:extension",
    :path => ":rails_root/public/system/employee/:id/:style/:basename.:extension",
    :styles => {
    :thumb=> "100x200>",
    :medium => "100x100>",
    :large => "300x400>"
  }
  validates_attachment_size :avatar, :less_than => 2.megabytes

  #  has_attached_file :avatar, :styles => { :medium => "100x100>", :thumb => "100x100>" }
  #  validates_attachment_size :avatar, :less_than => 2.megabytes
  validates :name, :email, :gender, :status, :address1, :address2, :street, :city, :pin_code, :phone1, :date_of_birth, :presence => true
  validates :name,:email, :uniqueness => true

  #  has_many :employee_roles
  #  has_many :roles, :through => :employee_roles
  has_many :employee_locations, :dependent => :destroy
  has_many :locations , :through => :employee_locations
  has_many :leave_applications, :dependent => :destroy
  belongs_to :employee_type, :foreign_key =>'employee_type_id'
  has_one :user
  has_many :payments
  has_many :appointments, :dependent => :destroy
  has_many :guests

  has_many :employee_services, :dependent => :destroy
  has_many :services, :through => :employee_services

  define_index do
    indexes name, :sortable => true
    #    indexes location, :sortable => true
  end
  #

#  def validate
#    #  errors.add :country, "You must select a state" if country == 'None'
#    if location_ids.to_a.empty?
#      errors.add :location_ids, "Please select atleast one location"
#    end
#
#  end

  #

  def assign_roles(role_ids)
    selected_roles = !role_ids.to_a.empty? ? Role.find(:all, :conditions => ["id IN (#{role_ids.to_a.uniq.join(', ')})"]) : []
    self.employee_roles.each do |e_l|
      if selected_roles.map{|l| l.id}.include?(e_l.role_id)
        selected_roles.delete_if{|sl| sl.id == e_l.role_id}
      else
        self.employee_roles.delete(e_l)
      end
    end
    self.roles << selected_roles
  end
end    
