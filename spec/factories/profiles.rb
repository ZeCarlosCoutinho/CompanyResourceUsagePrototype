FactoryBot.define do
  factory :profile do
    name { 'Darth Vader' }
    is_manager { false }
    user { FactoryBot.create(:user) }

    factory :employee do
      is_manager { false }
    end

    factory :manager do
      is_manager { true }
    end
  end
end
