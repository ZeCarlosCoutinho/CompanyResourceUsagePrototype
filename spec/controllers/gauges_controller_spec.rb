require 'rails_helper'

RSpec.describe GaugesController, type: :controller do
  before(:each) { sign_in current_profile.user }

  describe 'GET index' do
    render_views
    let(:current_profile) { FactoryBot.create(:manager) }

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

  describe 'POST create' do
    let(:current_profile) { FactoryBot.create(:employee) }

    subject do
      post "create", params: { gauge: {
        unit: unit,
        name: name,
        start_date: start_date,
        end_date: end_date
      } }
    end

    context 'when all the parameters are valid' do
      let(:unit) { 'testunit' }
      let(:name) { 'testname' }
      let(:start_date) { Time.zone.yesterday }
      let(:end_date) { Time.zone.today }

      it 'returns a 302 status code' do
        subject
        expect(response).to have_http_status(302)
      end

      it 'creates a gauge' do
        expect { subject }.to change(Gauge, :count).from(0).to(1)
        created_gauge = Gauge.find_by(name: name)
        expect(created_gauge.unit).to eq(unit)
        expect(created_gauge.start_date).to eq(start_date)
        expect(created_gauge.end_date).to eq(end_date)
      end
    end

    context 'when some of the parameters are invalid' do
      # All the gauge parameter validations are tested in the model specs.
      # The controller specs only test if the controller returns the appropriate response when invalid.

      it 'returns a 400 status code' do
        # TODO
      end

      it 'does not create a gauge' do
        # TODO
      end
    end

    context 'when the user is not authorized to create a gauge' do
      # TODO
    end
  end
end
