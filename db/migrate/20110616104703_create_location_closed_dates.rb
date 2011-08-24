class CreateLocationClosedDates < ActiveRecord::Migration
  def self.up
    create_table :location_closed_dates do |t|
      t.integer :location_id
      t.date :closed_date
      t.text :description
      t.string :created_by
    end
  end

  def self.down
    drop_table :location_closed_dates
  end
end
