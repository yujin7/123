class AddAllergiesColumnToGuestsTable < ActiveRecord::Migration
  def self.up
    add_column :guests, :allergies, :text
    add_column :guests, :formulas, :text
  end

  def self.down
    remove_column :guests, :allergies
    remove_column :guests, :formulas
  end
end
