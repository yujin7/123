class LeaveApplicationsTableChanges < ActiveRecord::Migration
  def self.up
    change_column :leave_applications, :leave_approval, :string, :default => "pending_approval"
  end

  def self.down
    change_column :leave_applications, :leave_approval, :boolean
  end
end
