# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

employee1_email = 'employee1@example.com'
employee1 = User.find_by(email: employee1_email)
employee1 ||= User.new(email: employee1_email, password: 'testtest')
# employee1.skip_confirmation!
employee1_profile = employee1.profile
employee1_profile ||= Profile.create(name: "Darth Vader", is_manager: false, user: employee1)
employee1.save!

employee2_email = 'employee2@example.com'
employee2 = User.find_by(email: employee2_email)
employee2 ||= User.new(email: employee2_email, password: 'testtest')
# employee2.skip_confirmation!
employee2_profile = employee2.profile
employee2_profile ||= Profile.create(name: "Darth Maul", is_manager: false, user: employee2)
employee2.save!

manager1_email = 'employee3@example.com'
manager1 = User.find_by(email: manager1_email)
manager1 ||= User.new(email: manager1_email, password: 'testtest')
# manager1.skip_confirmation!
manager1_profile = manager1.profile
manager1_profile ||= Profile.create(name: "Emperor Palpatine", is_manager: true, user: manager1)
manager1.save!

manager2_email = 'employee4@example.com'
manager2 = User.find_by(email: manager2_email)
manager2 ||= User.new(email: manager2_email, password: 'testtest')
# manager2.skip_confirmation!
manager2_profile = manager2.profile
manager2_profile ||= Profile.create(name: "Darth Sidious", is_manager: true, user: manager2)
manager2.save!

gauge1 = Gauge.find_by(name: "Test Gauge 1")
gauge1 ||= Gauge.new(name: "Test Gauge 1",
                  unit: 'kWh',
                  time_slot: Gauge.time_slots[:daily],
                  start_date: 1.month.ago,
                  end_date: Date.today.next_month)
gauge1.save!
