class CreatePermissionRoles < ActiveRecord::Migration
  def self.up
    create_table :permission_roles do |t|
      t.integer :role_id
      t.integer :permission_id
      t.integer :tab_id
      t.timestamps
    end
  end

  def self.down
    drop_table :permission_roles
  end
end
