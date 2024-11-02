class CreateGauges < ActiveRecord::Migration[7.2]
  def change
    create_table :gauges do |t|
      t.timestamps
      t.string :unit, null: false
      t.string :time_slot, null: false
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.string :name, null: false
    end
  end
end
