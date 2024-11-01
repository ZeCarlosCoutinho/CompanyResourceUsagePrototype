class Gauge < ApplicationRecord
  enum time_slot: [ :daily, :weekly, :monthly, :yearly ]
end
