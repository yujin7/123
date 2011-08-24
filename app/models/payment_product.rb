class PaymentProduct < ActiveRecord::Base
  belongs_to :product, :foreign_key => 'product_id'
  belongs_to :payment, :foreign_key => 'payment_id'
end
