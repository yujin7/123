class EmployeesService < ActiveRecord::Base
  belongs_to :service, :foreign_key => 'service_id'
  belongs_to :employee, :foreign_key => 'employee_id'
end
