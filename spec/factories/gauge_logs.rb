FactoryBot.define do
  factory :gauge_log do
    gauge { FactoryBot.create(:gauge) }
    filled_in_by { FactoryBot.create(:profile) }
    value { 42 }
  end
end
