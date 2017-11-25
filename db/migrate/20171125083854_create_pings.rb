class CreatePings < ActiveRecord::Migration[5.1]
  def change
    create_table :pings do |t|
      t.string :device_id
      t.integer :epoch_time

      t.timestamps
    end
  end
end
