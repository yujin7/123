class AppointmentPayment < ActiveRecord::Base
  belongs_to :guest, :foreign_key => 'commission_to'
  belongs_to :appointment

  validates :total, :amount_paid, :balance_due, :payment_mode, :presence => true
  validates_numericality_of :amount_paid, :balance_due, :cash
end
