class CreateAppointmentPayments < ActiveRecord::Migration
  def self.up
    create_table :appointment_payments do |t|
      t.string :customer_name
      t.string :customer_email
      t.string :billing_address1
      t.string :billing_address2
      t.string :customer_billing_phone
      t.string :customer_order_no
      t.datetime :date_created
      t.string :total
      t.string :amount_paid
      t.string :balance_due
      t.string :item_name
      t.string :commission_to
      t.string :commission
      t.string :quantity
      t.string :price
      t.string :discounts
      t.string :final_price
      t.string :payment_mode
      t.string :card_type
      t.string :cash
      t.text :address1
      t.text :address2
      t.string :street
      t.string :city
      t.string :phone1
      t.string :pin_code
      t.string :country
      t.string :card_number
      t.integer :appointment_id

      t.timestamps
    end
  end

  def self.down
    drop_table :appointment_payments
  end
end
