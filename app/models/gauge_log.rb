class GaugeLog < ApplicationRecord
  belongs_to :gauge
  belongs_to :filled_in_by, class_name: "Profile"
  belongs_to :approved_by, class_name: "Profile", optional: true

end
