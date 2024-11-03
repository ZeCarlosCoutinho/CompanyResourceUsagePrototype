FactoryBot.define do
  factory :gauge do
    unit { 'kWh' }
    time_slot { Gauge.time_slots[:daily] }
    start_date { Time.zone.today }
    end_date { Time.zone.today }
    name { 'Example Gauge' }
  end
end
