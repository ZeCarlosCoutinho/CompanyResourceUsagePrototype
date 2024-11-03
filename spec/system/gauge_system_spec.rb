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

    within("div#gauge#{gauge1.id}") do
      expect(page).to have_text(gauge1.name)
      expect(page).to have_text(gauge1.unit)
      expect(page).to have_text(gauge1.start_date.to_fs)
      expect(page).to have_text(gauge1.end_date.to_fs)
    end

    within("div#gauge#{gauge2.id}") do
      expect(page).to have_text(gauge2.name)
      expect(page).to have_text(gauge2.unit)
      expect(page).to have_text(gauge2.start_date.to_fs)
      expect(page).to have_text(gauge2.end_date.to_fs)
    end
  end

  it 'allows me to inspect each gauge' do
    visit '/gauge/index'

    within("div#gauge#{gauge1.id}") do
      expect(page).to have_link('Inspect', href: "/gauge/show?id=#{gauge1.id}")
    end

    within("div#gauge#{gauge2.id}") do
      expect(page).to have_link('Inspect', href: "/gauge/show?id=#{gauge2.id}")
    end

    click_link('Inspect', href: "/gauge/show?id=#{gauge2.id}")
    expect(page).to have_current_path("/gauge/show?id=#{gauge2.id}")
  end

  context 'if I am an employee' do
    let(:employee) { FactoryBot.create(:profile, is_manager: false) }
    subject { employee.user }

    it 'shows me the option to create a new gauge' do
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

  describe 'creating a new gauge' do
    context 'if I am an employee' do
      let(:employee) { FactoryBot.create(:employee) }
      subject { employee.user }

      it 'shows me the page to create a new gauge' do
        visit '/gauge/new'

        new_gauge_name = "New Test Gauge"
        new_gauge_unit = "km"

        expect(page).to have_field("Name", type: 'text')
        expect(page).to have_field("Unit", type: 'text')
        expect(page).to have_field("Start date", type: 'date')
        expect(page).to have_field("End date", type: 'date')
        expect(page).to have_button("Create Gauge")
      end
    end

    context 'if I am a manager' do
      let(:manager) { FactoryBot.create(:manager) }
      subject { manager.user }

      it 'shows me a forbidden page' do
        visit '/gauge/new'

        expect(page.status_code).to eq(403)
      end
    end
  end
end
