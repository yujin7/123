class CreateCashRegisters < ActiveRecord::Migration
  def self.up
    create_table :cash_registers do |t|
      t.datetime  :cash_on_date
      t.integer   :total_cash
      t.string    :user_entered_cash
    end
  end

  def self.down
    drop_table :cash_registers
  end
end
