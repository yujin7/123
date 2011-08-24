class LeaveApplication < ActiveRecord::Base
  attr_accessible :from, :to,:type_of_leave, :reason_for_leave, :leave_approval
  belongs_to :employee, :foreign_key => 'employee_id'
end
