class EmployeeType < ActiveRecord::Base
  has_many :employees, :foreign_key =>'employee_type_id'
end
