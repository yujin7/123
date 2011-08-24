class PaymentService < ActiveRecord::Base
  belongs_to :service, :foreign_key => 'service_id'
  belongs_to :payment, :foreign_key => 'payment_id'

   scope :all_service, lambda { |id|
    where("payment_id = #{id}")
  }
end
