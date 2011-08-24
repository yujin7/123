class CreateTaxtypes < ActiveRecord::Migration
  def self.up
    create_table :taxtypes do |t|
      t.string :name, :limit => 200
      t.string :rate, :limit => 5
      t.boolean :item
      t.string :status
      t.timestamps
    end
  end

  def self.down
    drop_table :taxtypes
  end
end
