class Gauge < ApplicationRecord
  enum time_slot: [ :daily, :weekly, :monthly, :yearly ]

  validates :unit, presence: true
  validates :time_slot, presence: true
  validates :name, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
end
