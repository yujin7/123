class CreatePaymentServices < ActiveRecord::Migration
  def self.up
    create_table :payment_services do |t|
      t.integer :payment_id
      t.integer :service_id
      t.timestamps
    end
  end

  def self.down
    drop_table :payment_services
  end
end
