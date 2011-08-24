class Package < ActiveRecord::Base
  attr_accessor :service_ids
  has_many :package_services, :dependent => :destroy
  has_many :services, :through => :package_services
  has_many :appointments
  has_many :payments
  has_many :guest_packages, :dependent => :destroy
  has_many :guests, :through => :guest_packages

  define_index do
    indexes name, :sortable => true
    #    indexes email, :sortable => true
    #    indexes billing_telephone, :sortable => true
    indexes status, :sortable => true
    #    indexes preferred_spa_location, :sortable => true
  end
  validates :name, :presence => true
  validates :name, :uniqueness => true


#  def assign_services(service_ids)
#    selected_services = !service_ids.to_a.empty? ? Service.find(:all, :conditions => ["id IN (#{service_ids.to_a.uniq.join(', ')})"]) : []
#    self.package_services.each do |e_l|
#      if selected_services.map{|l| l.id}.include?(e_l.service_id)
#        selected_services.delete_if{|sl| sl.id == e_l.service_id}
#      else
#        self.pacakge_services.delete(e_l)
#      end
#    end
#    self.services << selected_services
#  end
  #
  #  def self.total_price_after_discount(service_total, discount)
  #    puts service_total
  #    puts discount
  #    puts ">>>>>>>"
  #    disc_total = (discount.to_f/100)
  #    puts disc_total
  #    serv_total = disc_total * service_total
  #    puts serv_total
  #    total1 = service_total - serv_total
  #    puts total1
  #    return total1
  #  end


  def total_price
    t_price = services.map{|s| s.rate.to_f}.sum
    #    t_price += self.payment_products.map{|pp| pp.product_cost}.sum
    t_price -= (t_price * ((discount.to_f)/100))
    return t_price
  end
  #  scope :all_discount, lambda { |discount, services|
  #
  #    where("package_services.discount = #{discount}")
  #
  #  }


end
