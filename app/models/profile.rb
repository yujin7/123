class Profile < ActiveRecord::Base
  #  require 'csv'
  validates :first_name, :last_name, :role_name, :date_of_birth, :status, :residential_addr, :studio, :studio_joined_date, :studio_assigned, :contact_residence, :contact_hp, :email, :leave_entitlement, :supervisor, :presence => true
  validates :first_name, :last_name, :format => {:with => /[A-Za-z]/}, :presence => {:message => 'Only alphabets allowed'}
  validates :leave_entitlement, :format  => { :with => /[0-9]/ }
  validates_uniqueness_of :email
  validates_format_of :email, :with => RE_EMAIL_OK

  define_index do
    indexes first_name, :sortable => true
    indexes last_name, :sortable => true
    indexes email, :sortable => true
    indexes status, :sortable => true
    #    indexes preferred_spa_location, :sortable => true
  end
end
