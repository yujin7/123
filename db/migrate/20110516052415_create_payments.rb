class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table :payments do |t|
      t.integer :employee_id
      t.integer :package_id
      t.integer :gift_voucher_id
      t.string :discount
      t.text :remarks
      t.string :payment_mode
      t.string :taxable_amount
      t.string :status
      t.timestamps
    end
  end

  def self.down
    drop_table :payments
  end
end
