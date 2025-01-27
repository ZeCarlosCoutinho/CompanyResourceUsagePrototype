require 'rails_helper'

RSpec.describe GaugesController, type: :controller do
  before(:each) { sign_in current_profile.user }

  describe 'GET index' do
    let(:unit1) { 'testunit' }
    let(:name1) { 'testname' }
    let(:timeslot1) { Gauge.time_slots[:daily] }
    let(:start_date1) { Time.zone.yesterday }
    let(:end_date1) { Time.zone.today }
    let(:gauge1) do
      FactoryBot.create(:gauge, unit: testunit1,
                                name: testname1,
                                time_slot: timeslot1,
                                start_date: start_date1,
                                end_date: end_date1)
    end

    let(:unit2) { 'testunit2' }
    let(:name2) { 'testname2' }
    let(:timeslot2) { Gauge.time_slots[:weekly] }
    let(:start_date2) { Time.zone.yesterday - 1.week }
    let(:end_date2) { Time.zone.today - 1.week }
    let(:gauge2) do
      FactoryBot.create(:gauge, unit: testunit2,
                                name: testname2,
                                time_slot: timeslot2,
                                start_date: start_date2,
                                end_date: end_date2)
    end

    let(:current_profile) { FactoryBot.create(:manager) }
    subject { get "index" }

    it 'lists all the gauges' do
      # TODO
    end

    it 'returns a 200 status code', focus: true do
      subject
      expect(response.status).to eq(200)
    end
  end
end
