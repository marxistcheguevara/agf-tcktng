class CreateCashierLogs < ActiveRecord::Migration
  def change
    create_table :cashier_logs do |t|
      t.integer :cashier_id
      t.string :action
      t.datetime :datetime

      t.timestamps null: false
    end
  end
end
