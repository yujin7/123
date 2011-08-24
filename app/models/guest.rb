class Guest < ActiveRecord::Base
  #  profanity_filter :name
  require 'country_select'
  attr_accessor :packages_ids

  has_attached_file :avatar,
    :default_url => "/images/default_avatar.jpg",
    :url =>  "/system/guests/:id/:style/:basename.:extension",
    :path => ":rails_root/public/system/guests/:id/:style/:basename.:extension",
    :styles => {
    :thumb=> "100x200>",
    :medium => "100x100>"
  }
  validates_attachment_size :avatar, :less_than => 2.megabytes
  #  has_attached_file :avatar, :styles => { :medium => "100x100>", :thumb => "100x100>" }
  has_many :appointments
  has_many :appointment_payments
  belongs_to :location, :foreign_key => 'location_id'
  belongs_to :employee, :foreign_key => 'employee_id'
  belongs_to :membership, :foreign_key => 'membership_id'
  has_many :guest_packages, :dependent => :destroy
  has_many :packages, :through => :guest_packages
  has_one :guest_custom_field, :dependent => :destroy
  has_many :guest_notes, :dependent => :destroy
  has_many :progress_notes, :class_name => "GuestNote", :conditions => ["note_type = 'progress'"], :order => "created_at DESC"
  has_many :customer_notes, :class_name => "GuestNote", :conditions => ["note_type = 'customer'"], :order => "created_at DESC"
  has_many :payments
  # indexing for sphinax search
  define_index do
    indexes name, :sortable => true
    indexes email, :sortable => true
    indexes billing_telephone, :sortable => true
    indexes status, :sortable => true
  end
  
  validates :name, :gender, :date_of_birth, :billing_address_one, :billing_address_two, :billing_telephone, :shipping_address_one, :shipping_telephone, :presence => true
  #  validates_numericality_of :billing_pin_code, :billing_telephone, :billing_mobile, :shipping_pin_code, :shipping_telephone, :shipping_mobile
  #  validates_length_of :billing_pin_code, :maximum => 25
  #  validates_length_of :shipping_pin_code, :maximum => 25
  validates :email, :presence => true
  validates :email, :uniqueness => true
  #  validates_format_of :email, :with => RE_EMAIL_OK

  scope :active, where("status != 'Deleted'")
  scope :deleted, where("status = 'Deleted'")

  def assign_packages(package_ids)
    selected_packages = !package_ids.to_a.empty? ? Package.find(:all, :conditions => ["id IN (#{package_ids.to_a.uniq.join(', ')})"]) : []
    self.guest_packages.each do |g_p|
      if selected_packages.map{|p| p.id}.include?(g_p.package_id)
        selected_packages.delete_if{|sp| sp.id == g_p.package_id}
      else
        #        self.guest_packages.delete(g_p)
        GuestPackage.destroy_all(["package_id = #{g_p.package_id} and guest_id = #{self.id}"])
      end
    end
    if package_ids.to_a.empty?
      self.packages = []
    else
      self.packages = (self.packages + selected_packages).uniq
    end

    #    puts "SSSSSSSSSSSs"
    #    puts self.guest_packages.inspect
    #    #    self.guest_packages.each do |e_l|
    #    exists_packages = self.guest_packages
    #    for e_l in exists_packages
    #      if selected_packages.map{|l| l.id}.include?(e_l.package_id)
    #        puts "??????? DDDDD"
    #        puts e_l.package_id
    #        selected_packages.delete_if{|sp| sp.id == e_l.package_id}
    #      else
    #        self.guest_packages.delete(e_l)
    #      end
    #    end
    #    if package_ids.to_a.empty?
    #      self.packages = []
    #    else
    #      self.packages = (self.packages + selected_packages).uniq
    #    end
    
  end




  def self.draw(posts)
    pdf = PDF::Writer.new
    posts.each do |post|
      pdf.text product.name
    end
    pdf.render

  end

  def age
    uage = ""
    if self.date_of_birth
      #      (Date.today - self.date_of_birth).to_i/364
      now = Time.now.utc.to_date
      uage = now.year - self.date_of_birth.year - ((now.month > self.date_of_birth.month || (now.month == self.date_of_birth.month && now.day >= self.date_of_birth.day)) ? 0 : 1)
    end
    return uage
  end
  
end
