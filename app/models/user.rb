require 'country_select'
class User < ActiveRecord::Base
  acts_as_authentic
  attr_accessible :password, :password_confirmation, :login, :email, :employee_id, :primary_location_id
  validates :employee_id, :uniqueness => true, :allow_nil => true
  validates :primary_location_id, :presence => true
  has_many :role_users, :dependent => :destroy
  has_many :roles, :through => :role_users
  belongs_to :location, :foreign_key => 'primary_location_id'
  belongs_to :employee, :foreign_key => 'employee_id'
  has_many :guest_notes, :dependent => :destroy

  def assign_roles(role_ids)
    selected_roles = !role_ids.to_a.empty? ? Role.find(:all, :conditions => ["id IN (#{role_ids.to_a.uniq.join(', ')})"]) : []
    self.role_users.each do |e_l|
      if selected_roles.map{|l| l.id}.include?(e_l.role_id)
        selected_roles.delete_if{|sl| sl.id == e_l.role_id}
      else
        self.role_users.delete(e_l)
      end
    end
    self.roles << selected_roles
  end

  def activate!
    self.active = true
    save
  end

  def self.has_permission(name)
    if current_user.role.permissions.map{|permission| permission.name}.include?(name)
      return true
    else
      return false
    end
  end
 
  def activation_instructions
    reset_perishable_token!
    UserMailer.activation(self).deliver
  end

  def welcome
    reset_perishable_token!
    UserMailer.welcome(self).deliver
  end


  def deliver_password_reset_instructions!
    reset_perishable_token!
    UserMailer.deliver_password_reset_instructions(self)
  end

  def is_admin?
    return roles.map{|role| role.name}.include?("Admin")
  end

  def full_name
    self.login.to_s.capitalize
  end


end
