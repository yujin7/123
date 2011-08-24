class CreateGuests < ActiveRecord::Migration
  def self.up
    create_table :guests do |t|
      t.string :name, :limit => 200
      t.string  :email, :limit => 200
      t.string  :gender, :limit => 50
      t.string  :status, :limit => 100
      t.date  :date_of_birth
      t.date  :date_of_anniversary
      t.string  :billing_address_one, :limit => 200
      t.string  :billing_address_two, :limit => 200
      t.string  :billing_street   , :limit => 200
      t.string  :billing_city , :limit => 200
      t.string  :billing_country
      t.integer  :billing_pin_code, :limit => 25
      t.integer  :billing_telephone, :limit => 200
      t.integer  :billing_mobile, :limit => 200
      t.string  :shipping_address_one, :limit => 200
      t.string  :shipping_address_two, :limit => 200
      t.string  :shipping_street   , :limit => 200
      t.string  :shipping_city , :limit => 200
      t.string  :shipping_country
      t.integer  :shipping_pin_code, :limit => 25
      t.integer  :shipping_telephone, :limit => 200
      t.integer  :shipping_mobile, :limit => 200
      t.boolean  :email_alerts
      t.boolean  :sms_alerts
      t.string :preferred_spa_location
      t.string   :preferred_person, :limit => 20
      t.string   :preferred_staff, :limit => 40
      t.string   :membership_type, :limit => 20
      t.datetime  :last_visited_at
      t.string  :avatar_file_name
      t.string  :avatar_content_type
      t.integer  :avatar_file_size
      t.string :avatar_updated_at
      t.string :service_package, :limit => 20
      t.timestamps
    end
  end

  def self.down
    drop_table :guests
  end
end
