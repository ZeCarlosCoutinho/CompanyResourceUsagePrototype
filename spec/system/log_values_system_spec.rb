require 'rails_helper'

RSpec.describe "Value Logging", type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:start_date) { 1.month.ago }
  let(:end_date) { Date.today.next_month }
  let!(:target_gauge) { FactoryBot.create(:gauge, start_date: start_date, end_date: end_date) }

  subject { profile.user }
  before(:each) { sign_in(subject) }

  context 'if I am an employee' do
    let(:profile) { FactoryBot.create(:employee) }

    it 'allows me to log a value for a gauge' do
      visit "/gauge/show?id=#{target_gauge.id}"

      expect(page).to have_field("add-value-input", type: 'number')
      expect(page).to have_field("add-date-input", type: 'date')
      expect(page).to have_button("Add")

      chosen_value = 42
      chosen_date = Date.today
      fill_in "add-value-input", with: chosen_value
      fill_in "add-date-input", with: chosen_date.to_fs

      expect { click_button("Add") }.to change(GaugeLog, :count).by(1)
      new_gauge_log = target_gauge.gauge_logs.find_by(date: chosen_date)
      expect(new_gauge_log).to_not be_nil
      expect(new_gauge_log.value).to eq(chosen_value)
    end
  end
end
