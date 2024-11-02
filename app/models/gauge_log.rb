class GaugeLog < ApplicationRecord
  belongs_to :gauge
  belongs_to :filled_in_by, class_name: "Profile"
  belongs_to :approved_by, class_name: "Profile", optional: true

  validates :value, presence: true
  validates :date, presence: true

  def approve!(profile)
    return false unless profile.is_manager

    update(approved_by: profile)
  end
end
