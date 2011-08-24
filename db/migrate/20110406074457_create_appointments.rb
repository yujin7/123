class CreateAppointments < ActiveRecord::Migration
  def self.up

    create_table :appointments do |t|
      t.integer :guest_id
      t.boolean :service_enabled
      t.boolean :package_enabled
      t.integer :service_id
      t.integer :package_id
      t.datetime :time_in
      t.datetime :time_out
      t.string :customer_height_before
      t.string :customer_weight_before
      t.text :special_requests
      t.string :customer_height_after
      t.string :customer_weight_after
      t.text :comments
      t.string :status
      t.timestamps
    end
  end

  def self.down
    drop_table :appointments
  end
end
