class Membership < ActiveRecord::Base
  validates :name, :description, :quantity, :payment_plan_name, :payment_plan_desc, :initiation_fee,:total_price, :sales_tax,  :status,  :presence => true
  validates :name, :uniqueness => true
  has_many :membership_services, :dependent => :destroy
  has_many :services , :through => :membership_services
  has_many :guests
  
  attr_accessor :service_ids

  def assign_services(service_ids)
    selected_services = !service_ids.to_a.empty? ? Service.find(:all, :conditions => ["id IN (#{service_ids.to_a.uniq.join(', ')})"]) : []
    self.membership_services.each do |e_l|
      if selected_services.map{|l| l.id}.include?(e_l.service_id)
        selected_services.delete_if{|sl| sl.id == e_l.service_id}
      else
        self.membership_services.delete(e_l)
      end
    end
    self.services << selected_services
  end

  define_index do
    indexes name, :sortable => true
    indexes status, :sortable => true
  end

end
