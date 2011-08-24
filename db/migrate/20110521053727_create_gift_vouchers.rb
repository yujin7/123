class CreateGiftVouchers < ActiveRecord::Migration
  def self.up
    create_table :gift_vouchers do |t|
      t.integer :serial_no
      t.integer :percentage_discount
      t.float :discount_amount
      t.datetime :valid_upto
      t.timestamps
    end
  end

  def self.down
    drop_table :gift_vouchers
  end
end
