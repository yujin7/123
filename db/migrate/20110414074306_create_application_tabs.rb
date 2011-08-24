class CreateApplicationTabs < ActiveRecord::Migration
  def self.up
    create_table :application_tabs do |t|
      t.string :name
      t.timestamps
    end
    ApplicationTab.create(:name => 'appointments')
    ApplicationTab.create(:name => 'guests')
    ApplicationTab.create(:name => 'summary')
    ApplicationTab.create(:name => 'profile')
    ApplicationTab.create(:name => 'appts')
    ApplicationTab.create(:name => 'products')
    ApplicationTab.create(:name => 'notes')
    ApplicationTab.create(:name => 'ops')
    ApplicationTab.create(:name => 'settings')
    ApplicationTab.create(:name => 'employees')
  end

  def self.down
    drop_table :application_tabs
  end
end
