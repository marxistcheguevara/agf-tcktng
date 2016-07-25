class CreateHInOutRegister < ActiveRecord::Migration
  def change
    create_table :h_in_out_registers do |t|
      t.integer  :event_id
      t.string   :in_out
      t.datetime :last_in_out_date
      t.string   :seat_id
    end
  end
end
