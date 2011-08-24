class CreateEmployees < ActiveRecord::Migration
  def self.up
    create_table :employees do |t|
      t.integer :employee_type_id
      t.string :name, :limit => 200
      t.string :email, :limit => 200
      t.string :gender
      t.string :status, :default => 'Active'
      t.string :address1, :limit => 200
      t.string :address2, :limit => 200
      t.string :street, :limit => 200
      t.string :city, :limit => 200
      t.string :country
      t.integer :pin_code, :limit => 25
      t.integer :phone1 , :limit => 200
      t.integer :phone2 , :limit => 200
      t.date  :date_of_birth
      t.string  :avatar_file_name
      t.string  :avatar_content_type
      t.integer  :avatar_file_size
      t.string :avatar_updated_at
      t.string :notes, :limit => 500   

      t.timestamps
    end
  end

  def self.down
    drop_table :employees
  end
end
