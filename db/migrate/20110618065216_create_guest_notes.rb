class CreateGuestNotes < ActiveRecord::Migration
  def self.up
    create_table :guest_notes do |t|
      t.integer :guest_id
      t.integer :user_id
      t.string :note_type, :limit => 16
      t.text :note
      t.datetime :created_at
    end
  end

  def self.down
    drop_table :guest_notes
  end
end
