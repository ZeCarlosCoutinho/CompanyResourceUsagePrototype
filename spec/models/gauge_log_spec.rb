require 'rails_helper'

RSpec.describe GaugeLog, type: :model do
  describe 'factory' do
    it 'generates a valid gauge' do
      expect(FactoryBot.create(:gauge_log)).to be_valid
    end
  end

  describe 'validations' do
    # TODO Validate the mandatory fields
    describe 'approved_by' do
      it 'is optional' do
        valid_log = FactoryBot.create(:gauge_log, approved_by: nil)
        expect(valid_log).to be_valid

        also_valid_log = FactoryBot.create(:gauge_log, approved_by: FactoryBot.create(:profile, is_manager: true))
        expect(also_valid_log).to be_valid
      end
    end
  end

  describe 'approve!' do
    subject { FactoryBot.create(:gauge_log) }

    context 'when the approving profile is a employee' do
      let(:employee) { FactoryBot.create(:profile, is_manager: false) }

      it 'does not do anything' do
        subject.approve!(employee)

        expect(subject.approved_by).to be_nil
      end

      it 'returns false' do
        expect(subject.approve!(employee)).to eq(false)
      end
    end

    context 'when the approving profile is a manager' do
      let(:manager) { FactoryBot.create(:profile, is_manager: true) }

      it 'adds the profile as the approver' do
        subject.approve!(manager)

        expect(subject.approved_by).to be(manager)
      end

      it 'returns true' do
        expect(subject.approve!(manager)).to eq(true)
      end
    end
  end

end
