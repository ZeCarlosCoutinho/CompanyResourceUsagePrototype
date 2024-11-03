require 'rails_helper'

RSpec.describe GaugeLogController, type: :controller do
  describe 'PATCH approve' do
    before(:each) { sign_in current_user }

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
  end
end
