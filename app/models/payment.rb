class Payment < ActiveRecord::Base

  attr_accessor :service_ids
  belongs_to :employee, :foreign_key => 'employee_id'
  belongs_to :gift_voucher, :foreign_key => 'gift_voucher_id'
  belongs_to :package, :foreign_key => 'package_id'

  has_many :payment_products, :dependent => :destroy
  has_many :products, :through => :payment_products
    
  has_many :payment_services, :dependent => :destroy
  has_many :services, :through => :payment_services
  
  #  validates :service_ids,  :presence => true
  validates :service_ids, :presence => {:message => 'Please select more than one service'}
  validates :employee_id, :package_id, :discount, :remarks, :taxable_amount, :payment_mode, :guest_id, :presence => true

  belongs_to :guest
  #  attr_accessor :service_ids, :payment_id, :product_id
  #  attr_accessor :product_ids
  #
  #
  scope :recent_by_guest, lambda{|guest_id, limit|
    {
      :conditions => "guest_id = #{guest_id}",
      :order => "updated_at DESC",
      :limit => limit
    }
  }

  def assign_services(service_ids)
    selected_services = service_ids.to_a.empty? ? Service.find(:all, :conditions => ["id IN (#{service_ids.to_a.uniq.join(', ')})"]) : []
    self.payment_services.each do |p_p|
      if selected_services.map{|p| p.id}.include?(p_p.service_id)
        selected_services.delete_if{|sp| sp.id == p_p.service_id}
      else
        self.payment_services.delete(p_p)
        #        PaymentService.destroy_all(["service_id = #{p_p.service_id} and payment_id = #{self.id}"])
      end
    end
    if service_ids.to_a.empty?
      self.services = []
    else
      self.services = (self.services + selected_services).uniq
    end
  end

  #    def self.total_payment(service_total, gift_voucher, discount, taxable_amount)
  #      puts '>>>>'
  #      total = service_total- gift_voucher
  #      puts total
  #      puts '////////'
  #      discounted_total = (total - (total * ((discount.to_f)/100)))
  #      puts discounted_total
  #      puts '........'
  #      amount_to_be_paid = taxable_amount + discounted_total
  #      puts amount_to_be_paid
  #      return amount_to_be_paid
  #    end

  def total_price
    t_price = services.map{|s| s.rate.to_f}.sum
    #    t_price += self.payment_products.map{|pp| pp.product_cost}.sum
    t_price -= (t_price * ((discount.to_f)/100))
    t_price -= gift_voucher ? gift_voucher.discount_amount.to_f : 0
    t_price -= taxable_amount.to_f
    return t_price
  end

end
