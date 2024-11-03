require 'rails_helper'

RSpec.describe GaugeLogController, type: :controller do
  before(:each) { sign_in current_user }

  describe 'PATCH approve' do
    let(:target_gauge_log) { FactoryBot.create(:gauge_log) }
    let(:target_id) { target_gauge_log.id }
    subject { patch :approve, params: { id: target_id } }

    context 'when the user is a manager' do
      let(:current_user) { FactoryBot.create(:manager).user }

      it 'returns a 200' do
        subject
        expect(response.status).to eq(200)
      end

      it 'approves the gauge log' do
        expect { subject }.to change { target_gauge_log.reload.approved_by }.from(nil).to(current_user.profile)
      end

      context 'and the gauge log is already approved' do
        let(:another_manager) { FactoryBot.create(:manager) }
        let(:target_gauge_log) { FactoryBot.create(:gauge_log, approved_by: another_manager) }

        it 'returns a 400' do
          subject
          expect(response.status).to eq(400)
        end

        it 'does not change the profile who approved the log' do
          expect { subject }.not_to change { target_gauge_log.reload.approved_by }
        end
      end

      context 'and the gauge log does not exist' do
        let(:target_id) { -1 }

        it 'returns a 404' do
          subject
          expect(response.status).to eq(404)
        end
      end
    end

    context 'when the user is a employee' do
      let(:current_user) { FactoryBot.create(:employee).user }

      it 'returns a 403' do
        subject
        expect(response.status).to eq(403)
      end

      it 'does not approve the log' do
        expect { subject }.not_to change { target_gauge_log.reload.approved_by }
      end
    end
  end

  describe 'POST create' do
    let(:start_date) { 1.month.ago }
    let(:end_date) { Date.today.next_month }
    let(:gauge) { FactoryBot.create(:gauge, start_date: start_date, end_date: end_date) }
    let(:gauge_id) { gauge.id }

    let(:value) { 41 }
    let(:date) { Date.today }

    subject do
      post :create, params: {
        gauge_log: {
          value: value,
          date: date,
          gauge_id: gauge_id
        }
      }
    end

    context 'when the user is an employee' do
      let(:current_user) { FactoryBot.create(:employee).user }

      it 'returns a 200' do
        subject
        expect(response.status).to eq(200)
      end

      it 'creates the gauge log' do
        expect { subject }.to change(GaugeLog, :count).by(1)
        created_gauge_log = GaugeLog.find_by(date: date)
        expect(created_gauge_log).to_not be_nil
        expect(created_gauge_log.value).to eq(value)
        expect(created_gauge_log.gauge.id).to eq(gauge.id)
      end

      context 'when the date is invalid' do
        let(:date) { start_date - 1.month }

        it 'returns a 400' do
          subject
          expect(response.status).to eq(400)
        end

        it 'does not create the gauge log' do
          expect { subject }.not_to change(GaugeLog, :count)
        end
      end

      context 'when the associated gauge does not exist' do
        let(:gauge_id) { -1 }

        it 'returns a 400' do
          subject
          expect(response.status).to eq(400)
        end

        it 'does not create the gauge log' do
          expect { subject }.not_to change(GaugeLog, :count)
        end
      end
    end

    context 'when the user is a manager' do
      let(:current_user) { FactoryBot.create(:manager).user }

      it 'returns a 403' do
        subject
        expect(response.status).to eq(403)
      end

      it 'does not create the gauge log' do
        expect { subject }.not_to change(GaugeLog, :count)
      end
    end
  end
end
