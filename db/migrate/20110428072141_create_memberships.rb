class CreateMemberships < ActiveRecord::Migration
  def self.up
    create_table :memberships do |t|
      t.string :name, :limit => 200
      t.text :description, :limit => 250
      t.boolean :loyalty_rewards
      t.string :reward_points
      t.boolean :has_benefits
      t.string :status, :default => 'Active'
      t.text :benefit_desc, :limit => 200
      t.string :quantity, :limit => 5
      t.date :expiry_date
      t.string :payment_plan_name, :limit => 25
      t.text :payment_plan_desc, :limit => 250
      t.string :initiation_fee, :limit => 3
      t.boolean :duration
      t.boolean :frequency
      t.string :total_price, :limit => 5
      t.string :sales_tax, :limit => 3
      t.string :comission, :default => 'none'
      t.timestamps
    end
  end

  def self.down
    drop_table :memberships
  end
end
