# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110622074316) do

  create_table "application_tabs", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "appointment_payments", :force => true do |t|
    t.string   "customer_name"
    t.string   "customer_email"
    t.string   "billing_address1"
    t.string   "billing_address2"
    t.string   "customer_billing_phone"
    t.string   "customer_order_no"
    t.datetime "date_created"
    t.string   "total"
    t.string   "amount_paid"
    t.string   "balance_due"
    t.string   "item_name"
    t.string   "commission_to"
    t.string   "commission"
    t.string   "quantity"
    t.string   "price"
    t.string   "discounts"
    t.string   "final_price"
    t.string   "payment_mode"
    t.string   "card_type"
    t.string   "cash"
    t.text     "address1"
    t.text     "address2"
    t.string   "street"
    t.string   "city"
    t.string   "phone1"
    t.string   "pin_code"
    t.string   "country"
    t.string   "card_number"
    t.integer  "appointment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "appointments", :force => true do |t|
    t.integer  "guest_id"
    t.boolean  "service_enabled"
    t.boolean  "package_enabled"
    t.integer  "service_id"
    t.integer  "package_id"
    t.datetime "time_in"
    t.datetime "time_out"
    t.string   "customer_height_before"
    t.string   "customer_weight_before"
    t.text     "special_requests"
    t.string   "customer_height_after"
    t.string   "customer_weight_after"
    t.text     "comments"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "room_id"
    t.integer  "employee_id"
  end

  create_table "cash_registers", :force => true do |t|
    t.datetime "cash_on_date"
    t.integer  "total_cash"
    t.string   "user_entered_cash"
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employee_locations", :force => true do |t|
    t.integer  "employee_id"
    t.integer  "location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employee_services", :force => true do |t|
    t.integer  "employee_id"
    t.integer  "service_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employee_types", :force => true do |t|
    t.string "employee_type"
  end

  create_table "employees", :force => true do |t|
    t.integer  "employee_type_id"
    t.string   "name",                :limit => 200
    t.string   "email",               :limit => 200
    t.string   "gender"
    t.string   "status",                             :default => "Active"
    t.string   "address1",            :limit => 200
    t.string   "address2",            :limit => 200
    t.string   "street",              :limit => 200
    t.string   "city",                :limit => 200
    t.string   "country"
    t.integer  "pin_code"
    t.integer  "phone1"
    t.integer  "phone2"
    t.date     "date_of_birth"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.string   "avatar_updated_at"
    t.string   "notes",               :limit => 500
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employees_services", :force => true do |t|
    t.integer "employee_id"
    t.integer "service_id"
  end

  create_table "equipments", :force => true do |t|
    t.integer  "location_id"
    t.string   "name",              :limit => 200
    t.integer  "total_number",      :limit => 8
    t.integer  "no_out_of_service"
    t.string   "description"
    t.string   "special_notes",     :limit => 250
    t.string   "status",            :limit => 200
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "code_number",       :limit => 30
  end

  create_table "equipments_services", :force => true do |t|
    t.integer "equipment_id"
    t.integer "service_id"
  end

  create_table "event_series", :force => true do |t|
    t.integer  "frequency",  :default => 1
    t.string   "period",     :default => "monthly"
    t.datetime "starttime"
    t.datetime "endtime"
    t.boolean  "all_day",    :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.string   "title"
    t.datetime "starttime"
    t.datetime "endtime"
    t.boolean  "all_day",         :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.integer  "event_series_id"
  end

  add_index "events", ["event_series_id"], :name => "index_events_on_event_series_id"

  create_table "gift_vouchers", :force => true do |t|
    t.integer  "serial_no"
    t.integer  "percentage_discount"
    t.float    "discount_amount"
    t.datetime "valid_upto"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "guest_custom_fields", :force => true do |t|
    t.integer  "guest_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "guest_notes", :force => true do |t|
    t.integer  "guest_id"
    t.integer  "user_id"
    t.string   "note_type",  :limit => 16
    t.text     "note"
    t.datetime "created_at"
  end

  create_table "guest_packages", :force => true do |t|
    t.integer  "guest_id"
    t.integer  "package_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "guests", :force => true do |t|
    t.string   "name",                 :limit => 200
    t.string   "email",                :limit => 200
    t.string   "gender",               :limit => 50
    t.string   "status",               :limit => 100
    t.date     "date_of_birth"
    t.date     "date_of_anniversary"
    t.string   "billing_address_one",  :limit => 200
    t.string   "billing_address_two",  :limit => 200
    t.string   "billing_street",       :limit => 200
    t.string   "billing_city",         :limit => 200
    t.string   "billing_country"
    t.integer  "billing_pin_code"
    t.integer  "billing_telephone"
    t.integer  "billing_mobile"
    t.string   "shipping_address_one", :limit => 200
    t.string   "shipping_address_two", :limit => 200
    t.string   "shipping_street",      :limit => 200
    t.string   "shipping_city",        :limit => 200
    t.string   "shipping_country"
    t.integer  "shipping_pin_code"
    t.integer  "shipping_telephone"
    t.integer  "shipping_mobile"
    t.boolean  "email_alerts"
    t.boolean  "sms_alerts"
    t.string   "preferred_person",     :limit => 20
    t.datetime "last_visited_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.string   "avatar_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "location_id"
    t.integer  "employee_id"
    t.integer  "membership_id"
    t.text     "allergies"
    t.text     "formulas"
  end

  create_table "hr_systems", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "inventories", :force => true do |t|
    t.integer "product_id"
    t.string  "name"
    t.integer "barcode"
    t.text    "description"
    t.integer "retail_price"
    t.integer "cost_price"
    t.integer "stock_balance"
    t.integer "balance_alert"
    t.string  "status"
  end

  create_table "leave_applications", :force => true do |t|
    t.integer  "employee_id"
    t.date     "from"
    t.date     "to"
    t.string   "type_of_leave"
    t.text     "reason_for_leave"
    t.string   "leave_approval",   :default => "pending_approval"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "location_closed_dates", :force => true do |t|
    t.integer "location_id"
    t.date    "closed_date"
    t.text    "description"
    t.string  "created_by"
  end

  create_table "location_equipments", :force => true do |t|
    t.integer "location_id"
    t.integer "equipment_id"
    t.string  "equipment_code_number"
    t.boolean "in_service"
  end

  create_table "location_operation_hours", :force => true do |t|
    t.integer "location_id"
    t.string  "operating_day"
    t.date    "operating_date"
    t.time    "open_time"
    t.time    "close_time"
  end

  create_table "locations", :force => true do |t|
    t.string   "name",              :limit => 200
    t.string   "address1",          :limit => 200
    t.string   "address2",          :limit => 200
    t.string   "street",            :limit => 200
    t.string   "city",              :limit => 200
    t.integer  "post_code"
    t.string   "country",           :limit => 200
    t.integer  "phone1"
    t.integer  "phone2"
    t.string   "fax",               :limit => 200
    t.string   "status",            :limit => 200, :default => "Active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "location_email_id", :limit => 100
    t.string   "code_number",       :limit => 30
  end

  create_table "membership_services", :force => true do |t|
    t.integer  "membership_id"
    t.integer  "service_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "memberships", :force => true do |t|
    t.string   "name",              :limit => 200
    t.text     "description"
    t.boolean  "loyalty_rewards"
    t.string   "reward_points"
    t.boolean  "has_benefits"
    t.string   "status",                           :default => "Active"
    t.text     "benefit_desc"
    t.string   "quantity",          :limit => 5
    t.date     "expiry_date"
    t.string   "payment_plan_name", :limit => 25
    t.text     "payment_plan_desc"
    t.string   "initiation_fee",    :limit => 3
    t.boolean  "duration"
    t.boolean  "frequency"
    t.string   "total_price",       :limit => 5
    t.string   "sales_tax",         :limit => 3
    t.string   "comission",                        :default => "none"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "package_services", :force => true do |t|
    t.integer  "package_id"
    t.integer  "service_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "quantity"
  end

  create_table "packages", :force => true do |t|
    t.float    "total_price"
    t.string   "name"
    t.text     "description"
    t.string   "status",      :default => "active"
    t.integer  "discount",    :default => 0
    t.string   "deposit",     :default => "none"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payment_products", :force => true do |t|
    t.integer  "payment_id"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "quantity"
    t.integer  "product_cost"
  end

  create_table "payment_services", :force => true do |t|
    t.integer  "payment_id"
    t.integer  "service_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payments", :force => true do |t|
    t.integer  "employee_id"
    t.integer  "package_id"
    t.integer  "gift_voucher_id"
    t.string   "discount"
    t.text     "remarks"
    t.string   "payment_mode"
    t.string   "taxable_amount"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cash_card_number"
    t.integer  "guest_id"
  end

  create_table "permission_roles", :force => true do |t|
    t.integer  "role_id"
    t.integer  "permission_id"
    t.integer  "tab_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permissions", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_brands", :force => true do |t|
    t.string "product_brand"
  end

  create_table "products", :force => true do |t|
    t.string   "name",                :limit => 200
    t.text     "description"
    t.string   "status",              :limit => 200
    t.integer  "product_brand_id"
    t.integer  "category_id"
    t.integer  "sub_category_id"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.string   "avatar_updated_at"
    t.string   "ingredients",         :limit => 250
    t.integer  "sales_tax",           :limit => 3
    t.integer  "quantity",            :limit => 3
    t.string   "online_shop",         :limit => 250
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products_services", :force => true do |t|
    t.integer "service_id"
    t.integer "product_id"
    t.string  "quantity"
    t.integer "product_cost"
  end

  create_table "profiles", :force => true do |t|
    t.string   "first_name",         :limit => 200
    t.string   "last_name",          :limit => 200
    t.string   "role_name",          :limit => 200
    t.date     "date_of_birth"
    t.string   "status"
    t.text     "residential_addr"
    t.string   "studio"
    t.date     "studio_joined_date"
    t.string   "studio_assigned"
    t.integer  "contact_residence"
    t.integer  "contact_hp"
    t.string   "email",              :limit => 250
    t.integer  "leave_entitlement"
    t.string   "supervisor"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "role_users", :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "name",        :limit => 200
    t.string   "description"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "room_services", :force => true do |t|
    t.integer  "room_id"
    t.integer  "service_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rooms", :force => true do |t|
    t.integer  "location_id"
    t.string   "name",        :limit => 200
    t.integer  "capacity",    :limit => 3
    t.string   "description", :limit => 250
    t.string   "status",      :limit => 200, :default => "Active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "services", :force => true do |t|
    t.string   "service_name"
    t.integer  "category_id"
    t.integer  "sub_category_id"
    t.time     "duration"
    t.time     "staff_recovery_time"
    t.time     "room_recovery_time"
    t.boolean  "book_online"
    t.string   "rate"
    t.text     "special_notes"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "service_code"
    t.boolean  "requires_equipment"
  end

  create_table "statuses", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sub_categories", :force => true do |t|
    t.string   "name"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taxtypes", :force => true do |t|
    t.string   "name",       :limit => 200
    t.string   "rate",       :limit => 5
    t.boolean  "item"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_sessions", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email",                                  :null => false
    t.string   "crypted_password",                       :null => false
    t.string   "password_salt",                          :null => false
    t.string   "persistence_token",                      :null => false
    t.string   "single_access_token",                    :null => false
    t.string   "perishable_token",                       :null => false
    t.boolean  "active",              :default => false, :null => false
    t.integer  "login_count",         :default => 0,     :null => false
    t.integer  "failded_login_count", :default => 0,     :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "employee_id"
    t.integer  "primary_location_id"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["login"], :name => "index_users_on_login", :unique => true
  add_index "users", ["perishable_token"], :name => "index_users_on_perishable_token"
  add_index "users", ["persistence_token"], :name => "index_users_on_persistence_token", :unique => true

end
