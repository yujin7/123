class EmployeeLocation < ActiveRecord::Base
  belongs_to :location, :foreign_key => 'location_id'
  belongs_to :employee, :foreign_key => 'employee_id'
end
