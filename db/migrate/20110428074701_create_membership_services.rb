class CreateMembershipServices < ActiveRecord::Migration
  def self.up
    create_table :membership_services do |t|
      t.integer :membership_id
      t.integer :service_id
      t.timestamps
    end
  end

  def self.down
    drop_table :membership_services
  end
end
