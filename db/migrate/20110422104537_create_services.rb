class CreateServices < ActiveRecord::Migration
  def self.up
    create_table :services do |t|
      t.string :service_name
      t.integer :category_id
      t.integer :sub_category_id
      t.time :duration
      t.time :staff_recovery_time
      t.time :room_recovery_time
      t.string :book_online
      t.string :rate
      t.string :equipment
      t.text   :special_notes
      t.string :status
      t.integer :category_id
      t.timestamps
    end
  end

  def self.down
    drop_table :services
  end
end
