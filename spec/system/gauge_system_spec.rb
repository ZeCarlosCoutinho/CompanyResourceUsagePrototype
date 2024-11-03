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

      it 'allows me to create a new gauge' do
        visit '/gauge/new'

        new_gauge_name = "New Test Gauge"
        new_gauge_unit = "km"

        fill_in "Name", with: new_gauge_name
        fill_in "Unit", with: new_gauge_unit
        fill_in "Start date", with: 2.months.ago.to_fs
        fill_in "End date", with: Date.today.next_month.to_fs

        expect { click_button("Create Gauge") }.to change(Gauge, :count).by(1)
        new_gauge = Gauge.find_by(name: new_gauge_name)
        expect(new_gauge).to_not be_nil
        expect(new_gauge.unit).to eq(new_gauge_unit)
      end

      it 'returns a 400 if a parameter is invalid' do
        visit '/gauge/new'

        start_date = 2.months.ago.to_fs
        invalid_end_date = 3.months.ago.to_fs

        fill_in "Name", with: "New Test Gauge"
        fill_in "Unit", with: "km"
        fill_in "Start date", with: start_date
        fill_in "End date", with: invalid_end_date

        expect { click_button("Create Gauge") }.to_not change(Gauge, :count)
        expect(page.status_code).to eq(400)
      end
    end

    context 'if I am a manager' do
      let(:manager) { FactoryBot.create(:manager) }
      subject { manager.user }

      it 'shows me a forbidden page when I try to access the form' do
        visit '/gauge/new'

        expect(page.status_code).to eq(403)
      end
    end
  end

  describe 'inspecting a gauge' do
    let(:current_gauge) { gauge1 }
    let!(:gauge_log1) { FactoryBot.create(:gauge_log, gauge: current_gauge, filled_in_by: profile, value: 10, date: Date.today) }
    let!(:gauge_log2) { FactoryBot.create(:gauge_log, gauge: current_gauge, filled_in_by: profile, value: 20, date: Date.tomorrow) }

    let!(:gauge_log_from_another_gauge) { FactoryBot.create(:gauge_log, gauge: gauge2, filled_in_by: profile, value: 50, date: Date.yesterday) }

    it 'shows me the gauge\'s attributes' do
      visit "/gauge/show?id=#{current_gauge.id}"

      expect(page).to have_text(current_gauge.name)
      expect(page).to have_text(current_gauge.unit)
      expect(page).to have_text(current_gauge.start_date.to_fs)
      expect(page).to have_text(current_gauge.end_date.to_fs)
    end

    it 'shows me the gauge\'s logs' do
      visit "/gauge/show?id=#{current_gauge.id}"

      expect(page).to have_text(gauge_log1.value)
      expect(page).to have_text(gauge_log1.date.to_fs)
      expect(page).to have_text(gauge_log2.value)
      expect(page).to have_text(gauge_log2.date.to_fs)

      expect(page).to_not have_text(gauge_log_from_another_gauge.value)
      expect(page).to_not have_text(gauge_log_from_another_gauge.date.to_fs)
    end

    context 'if I am a manager' do
      subject { FactoryBot.create(:manager).user }

      it 'shows me an approve button for each gauge log of this gauge' do
        visit "/gauge/show?id=#{current_gauge.id}"

        within("#gauge-log-row#{gauge_log1.id}") do
          expect(page).to have_button("Approve")
        end

        within("#gauge-log-row#{gauge_log2.id}") do
          expect(page).to have_button("Approve")
        end

        expect(page).to_not have_selector("#gauge-log-row#{gauge_log_from_another_gauge.id}")
      end
    end

    context 'if I am an employee' do
      subject { FactoryBot.create(:employee).user }

      it 'does not show any approve buttons' do
        visit "/gauge/show?id=#{current_gauge.id}"

        within("#gauge-log-row#{gauge_log1.id}") do
          expect(page).to_not have_button("Approve")
        end

        within("#gauge-log-row#{gauge_log2.id}") do
          expect(page).to_not have_button("Approve")
        end
      end
    end
  end
end
