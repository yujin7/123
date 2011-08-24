class CreateProfiles < ActiveRecord::Migration
  def self.up
    create_table :profiles do |t|
      
      t.string :first_name, :limit => 200
      t.string :last_name, :limit => 200
      t.string :role_name, :limit => 200
      t.date :date_of_birth
      t.string :status
      t.text :residential_addr, :limit => 200
      t.string :studio
      t.date :studio_joined_date
      t.string :studio_assigned
      t.integer :contact_residence
      t.integer :contact_hp
      t.string :email, :limit => 250
      t.integer :leave_entitlement
      t.string :supervisor 
      t.timestamps
    end
  end

  def self.down
    drop_table :profiles
  end
end
