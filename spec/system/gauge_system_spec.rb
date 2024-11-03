require 'rails_helper'

RSpec.describe "Gauges management", type: :system do
  before do
    driven_by(:rack_test)
  end

  let!(:gauge1) { FactoryBot.create(:gauge, name: "Gauge1", unit: "kWh", start_date: 1.month.ago, end_date: Date.today.next_month) }
  let!(:gauge2) { FactoryBot.create(:gauge, name: "Gauge2", unit: "L", start_date: 2.months.ago, end_date: Date.today.next_month) }
  let!(:profile) { FactoryBot.create(:profile) }
  subject { profile.user }
  before(:each) { sign_in(subject) }

  it 'allows me to see all the gauges that exist' do
    visit '/gauge/index'

    within('div#gauge1') do
      expect(page).to have_text(gauge1.name)
      expect(page).to have_text(gauge1.unit)
      expect(page).to have_text(gauge1.start_date.to_fs)
      expect(page).to have_text(gauge1.end_date.to_fs)
    end

    within('div#gauge2') do
      expect(page).to have_text(gauge2.name)
      expect(page).to have_text(gauge2.unit)
      expect(page).to have_text(gauge2.start_date.to_fs)
      expect(page).to have_text(gauge2.end_date.to_fs)
    end
  end

  context 'if I am an employee' do
    let(:employee) { FactoryBot.create(:profile, is_manager: false) }
    subject { employee.user }

    it 'allows me to create a new gauge' do
      visit '/gauge/index'

      expect(page).to have_link('New Gauge', href: '/gauge/new')
      click_link 'New Gauge'

      expect(page).to have_current_path('/gauge/new')
    end
  end

  context 'if I am a manager' do
    let(:manager) { FactoryBot.create(:profile, is_manager: true) }
    subject { manager.user }

    it 'allows me to create a new gauge' do
      visit '/gauge/index'

      expect(page).to_not have_link('New Gauge', href: '/gauge/new')
    end
  end
end
