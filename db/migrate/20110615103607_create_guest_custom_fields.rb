class CreateGuestCustomFields < ActiveRecord::Migration
  def self.up
    create_table :guest_custom_fields do |t|
      t.column :guest_id, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :guest_custom_fields
  end
end
