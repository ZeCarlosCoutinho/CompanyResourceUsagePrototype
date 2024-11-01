class CreateProfiles < ActiveRecord::Migration[7.2]
  def change
    create_table :profiles do |t|
      t.timestamps
      t.string :name, null: false
      t.boolean :is_manager, null: false, default: false

      t.belongs_to :user, foreign_key: true, null: false, index: { unique: true }
    end
  end
end
