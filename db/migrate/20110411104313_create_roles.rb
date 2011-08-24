class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.string :name , :limit => 200
      t.string :description
      t.string :status
      t.timestamps
    end
    Role.create(:name => 'User', :description => 'The user role has minimal permissions.', :status => 'Active')
    Role.create(:name => 'Admin', :description => 'The admin role has all the permissions.', :status => 'Active')
  end

  def self.down
    drop_table :roles
  end
end
