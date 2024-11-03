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

  validate :end_is_after_start

  private

  def end_is_after_start
    return if end_date >= start_date

    errors.add(:end_date, "The end date must be the same or after the start date")
  end
end
