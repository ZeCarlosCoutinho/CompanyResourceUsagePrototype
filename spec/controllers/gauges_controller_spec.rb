require 'rails_helper'

RSpec.describe GaugesController, type: :controller do
  before(:each) { sign_in current_profile.user }

  describe 'GET index' do
    render_views
    let(:unit1) { 'testunit' }
    let(:name1) { 'testname' }
    let(:timeslot1) { Gauge.time_slots[:daily] }
    let(:start_date1) { Time.zone.yesterday }
    let(:end_date1) { Time.zone.today }
    let!(:gauge1) do
      FactoryBot.create(:gauge, unit: unit1,
                                name: name1,
                                time_slot: timeslot1,
                                start_date: start_date1,
                                end_date: end_date1)
    end

    let(:unit2) { 'testunit2' }
    let(:name2) { 'testname2' }
    let(:timeslot2) { Gauge.time_slots[:weekly] }
    let(:start_date2) { Time.zone.yesterday - 1.week }
    let(:end_date2) { Time.zone.today - 1.week }
    let!(:gauge2) do
      FactoryBot.create(:gauge, unit: unit2,
                                name: name2,
                                time_slot: timeslot2,
                                start_date: start_date2,
                                end_date: end_date2)
    end

    let(:current_profile) { FactoryBot.create(:manager) }
    subject { get "index" }

    it 'returns a 200 status code' do
      subject
      expect(response.status).to eq(200)
    end

    it 'lists all the gauges' do
      subject
      rendered_html = response.body
      expect(rendered_html).to match(/<h3>#{name1}<\/h3>/)
      expect(rendered_html).to match(/<li>Units: #{unit1}<\/li>/)
      expect(rendered_html).to match(/<li>Start Date: #{start_date1}<\/li>/)
      expect(rendered_html).to match(/<li>End Date: #{end_date1}<\/li>/)

      expect(rendered_html).to match(/<h3>#{name2}<\/h3>/)
      expect(rendered_html).to match(/<li>Units: #{unit2}<\/li>/)
      expect(rendered_html).to match(/<li>Start Date: #{start_date2}<\/li>/)
      expect(rendered_html).to match(/<li>End Date: #{end_date2}<\/li>/)
    end
  end
end
