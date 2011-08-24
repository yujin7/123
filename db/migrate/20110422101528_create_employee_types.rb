class CreateEmployeeTypes < ActiveRecord::Migration
  def self.up
    create_table :employee_types do |t|
      t.string :employee_type
    end
    EmployeeType.create(:employee_type => 'Freelancer')
    EmployeeType.create(:employee_type => 'Trainee')
    EmployeeType.create(:employee_type => 'Employed')
  end

  def self.down
    drop_table :employee_types
  end
end
