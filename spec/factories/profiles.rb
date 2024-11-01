FactoryBot.define do
  factory :profile do
    name { 'Darth Vader' }
    is_manager { false }
    user { FactoryBot.create(:user) }
  end
end
