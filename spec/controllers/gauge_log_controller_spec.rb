require 'rails_helper'

RSpec.describe GaugeLogController, type: :controller do
  before(:each) { sign_in current_profile.user }

  describe 'PATCH approve' do
    let(:target_gauge_log) { FactoryBot.create(:gauge_log) }
    let(:target_id) { target_gauge_log.id }
    subject { patch :approve, params: { id: target_id } }

    context 'when the user is a manager' do
      let(:current_profile) { FactoryBot.create(:manager) }

      it 'returns a 200' do
        subject
        expect(response.status).to eq(200)
      end

      it 'approves the gauge log' do
        expect { subject }.to change { target_gauge_log.reload.approved_by }.from(nil).to(current_profile)
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
      let(:current_profile) { FactoryBot.create(:employee) }

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
      let(:current_profile) { FactoryBot.create(:employee) }

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

      context 'when there is already another log for that date' do
        let(:different_value) { value + 1 }
        let!(:another_log) { FactoryBot.create(:gauge_log, gauge: gauge, date: date, value: different_value) }

        it 'returns a 400' do
          subject
          expect(response.status).to eq(400)
        end

        it 'does not create the log' do
          expect { subject }.to_not change(GaugeLog.where(date: date), :count)
        end

        it 'does not substitute the current log for that date' do
          expect { subject }.to_not change(GaugeLog.find_by(date: date), :value)
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
      let(:current_profile) { FactoryBot.create(:manager) }

      it 'returns a 403' do
        subject
        expect(response.status).to eq(403)
      end

      it 'does not create the gauge log' do
        expect { subject }.not_to change(GaugeLog, :count)
      end
    end
  end

  describe 'PATCH update' do
    let(:min_date) { 1.month.ago }
    let(:initial_value) { 42 }
    let(:initial_date) { Date.today }
    let(:gauge) { FactoryBot.create(:gauge, start_date: min_date, end_date: Date.today.next_month) }
    let(:target_gauge_log) { FactoryBot.create(:gauge_log, value: initial_value, date: initial_date, gauge: gauge) }
    let(:target_id) { target_gauge_log.id }
    let(:target_value) { 100.5 }
    let(:target_date) { Date.tomorrow }
    subject { patch :update, params: { gauge_log: { id: target_id, value: target_value, date: target_date } } }

    context 'when the user is an employee' do
      let(:current_profile) { FactoryBot.create(:employee) }
      it 'returns a 200' do
        subject
        expect(response.status).to eq(200)
      end

      it 'updates the log' do
        expect { subject }.to change { target_gauge_log.reload.value }.from(initial_value).to(target_value)
          .and(change { target_gauge_log.reload.date }.from(initial_date).to(target_date))
      end

      context 'and it tries to update other values besides value and date' do
        let(:manager) { FactoryBot.create(:manager) }
        let(:another_gauge) { FactoryBot.create(:gauge) }

        subject do
          patch :update, params: {
            gauge_log: {
              id: target_id,
              value: target_value,
              date: target_date,
              approved_by: manager,
              gauge: another_gauge
            }
          }
        end

        it 'returns a 200' do
          subject
          expect(response.status).to eq(200)
        end

        it 'updates the value and date attributes' do
          expect { subject }.to change { target_gauge_log.reload.value }.from(initial_value).to(target_value)
            .and(change { target_gauge_log.reload.date }.from(initial_date).to(target_date))
        end

        it 'does not update the other attributes' do
          expect { subject }.to not_change { target_gauge_log.reload.approved_by }
            .and(not_change { target_gauge_log.reload.gauge })
        end
      end

      context 'and the target log does not exist' do
        let(:target_id) { -1 }

        it 'returns a 404' do
          subject
          expect(response.status).to eq(404)
        end
      end

      context 'and it tries to update the log with invalid parameters' do
        let(:target_date) { min_date - 1.day }

        it 'returns a 400' do
          subject
          expect(response.status).to eq(400)
        end

        it 'does not update any attributes of the log' do
          expect { subject }.to not_change { target_gauge_log.reload.value }
            .and(not_change { target_gauge_log.reload.date })
        end
      end

      context 'and it tries to update a log that is already approved' do
        before(:each) do
          target_gauge_log.approve!(FactoryBot.create(:manager))
        end

        it 'returns a 400' do
          subject
          expect(response.status).to eq(400)
        end

        it 'does not update the log' do
          expect { subject }.to not_change { target_gauge_log.reload.value }
            .and(not_change { target_gauge_log.reload.date })
        end
      end
    end

    context 'when the user is a manager' do
      let(:current_profile) { FactoryBot.create(:manager) }

      it 'returns a 403' do
        subject
        expect(response.status).to eq(403)
      end

      it 'does not change the gauge log' do
        expect { subject }.to not_change { target_gauge_log.reload.value }
            .and(not_change { target_gauge_log.reload.date })
      end
    end
  end
end
