class CreatePermissions < ActiveRecord::Migration
  def self.up
    create_table :permissions do |t|
      t.string :name
      t.timestamps
    end
    Permission.create(:name => 'view')
    Permission.create(:name => 'create')
    Permission.create(:name => 'edit')
    Permission.create(:name => 'delete')
  end

  def self.down
    drop_table :permissions
  end
end
