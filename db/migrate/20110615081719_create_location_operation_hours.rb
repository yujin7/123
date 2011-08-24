class CreateLocationOperationHours < ActiveRecord::Migration
  def self.up
    create_table :location_operation_hours do |t|
      t.integer :location_id
      t.string :operating_day
      t.date   :operating_date
      t.time   :open_time
      t.time   :close_time
    end
  end

  def self.down
    drop_table :location_operation_hours
  end
end
