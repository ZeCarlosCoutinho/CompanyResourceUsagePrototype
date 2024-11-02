class GaugeLog < ApplicationRecord
  belongs_to :gauge
  belongs_to :filled_in_by, class_name: "Profile"
  belongs_to :approved_by, class_name: "Profile", optional: true

  validates :value, presence: true
  validates :date, presence: true

  validate :no_duplicates

  def approve!(profile)
    return false unless profile.is_manager

    update(approved_by: profile)
  end

  private

  def no_duplicates
    return unless gauge.gauge_logs.find_by(date: date)

    errors.add(:date, "There already exists a gauge_log for this date in the selected gauge")
  end
end
