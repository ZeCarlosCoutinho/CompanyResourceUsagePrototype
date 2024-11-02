class CreateGaugeLogs < ActiveRecord::Migration[7.2]
  def change
    create_table :gauge_logs do |t|
      t.timestamps
      t.belongs_to :gauge, null: false
      t.belongs_to :filled_in_by, foreign_key: { to_table: :profiles }, null: false
      t.belongs_to :approved_by, foreign_key: { to_table: :profiles }

      t.numeric :value, null: false
      t.date :date, null: false
    end
  end
end
