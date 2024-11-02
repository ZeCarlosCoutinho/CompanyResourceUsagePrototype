# The Gauge represents a gauge of the company, which stores several measurements of a certain resource
# along fixed periods of time.
class Gauge < ApplicationRecord
  has_many :gauge_logs

  enum time_slot: {
    daily: "daily",
    weekly: "weekly",
    monthly: "monthly",
    yearly: "yearly"
  }

  validates :unit, presence: true
  validates :time_slot, presence: true
  validates :name, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
end
