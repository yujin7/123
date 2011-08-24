class CreateLeaveApplications < ActiveRecord::Migration
  def self.up
    create_table :leave_applications do |t|
      t.integer :employee_id
      t.date :from
      t.date :to
      t.string :type_of_leave
      t.text :reason_for_leave
      t.boolean :leave_approval
      t.timestamps
    end
  end

  def self.down
    drop_table :leave_applications
  end
end
