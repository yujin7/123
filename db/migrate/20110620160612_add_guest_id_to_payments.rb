class AddGuestIdToPayments < ActiveRecord::Migration
  def self.up
    add_column :payments, :guest_id, :integer
  end

  def self.down
    remove_column :payments, :guest_id
  end
end
