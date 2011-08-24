class CreateHrSystems < ActiveRecord::Migration
  def self.up
    create_table :hr_systems do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :hr_systems
  end
end
