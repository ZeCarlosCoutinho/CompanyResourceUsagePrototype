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

    describe 'date' do
      context 'when a gauge log already exists for a given time slot' do
        let!(:gauge) { FactoryBot.create(:gauge, time_slot: Gauge.time_slots[:daily]) }
        let!(:other_gauge) { FactoryBot.create(:gauge, time_slot: Gauge.time_slots[:daily]) }
        let(:date) { Date.today }
        let(:other_date) { Date.yesterday }
        let!(:gauge_log1) { FactoryBot.create(:gauge_log, gauge: gauge, date: date) }

        it 'is invalid' do
          invalid_log = FactoryBot.build(:gauge_log, gauge: gauge, date: date)
          expect(invalid_log).to_not be_valid
          expect(invalid_log.errors[:date]).to match_array([ "There already exists a gauge_log for this date in the selected gauge" ])

          valid_log = FactoryBot.build(:gauge_log, gauge: other_gauge, date: date)
          expect(valid_log).to be_valid

          also_valid_log = FactoryBot.build(:gauge_log, gauge: gauge, date: other_date)
          expect(also_valid_log).to be_valid
        end

        it 'is valid for the gauge log that already exists' do
          expect(gauge_log1).to be_valid

          invalid_log = FactoryBot.build(:gauge_log, gauge: gauge, date: date)
          expect(invalid_log).to_not be_valid
          expect(invalid_log.errors[:date]).to match_array([ "There already exists a gauge_log for this date in the selected gauge" ])
        end
      end

      it 'must fall between the start and end date of the associated gauge' do
        gauge = FactoryBot.create(:gauge, start_date: Date.yesterday, end_date: Date.today)
        valid_date = Date.today
        invalid_date = Date.tomorrow
        also_invalid_date = 2.days.ago

        invalid_log = FactoryBot.build(:gauge_log, gauge: gauge, date: invalid_date)
        expect(invalid_log).to_not be_valid
        expect(invalid_log.errors[:date]).to match_array([ "Date must fall between the gauge\'s start and end date" ])

        also_invalid_log = FactoryBot.build(:gauge_log, gauge: gauge, date: also_invalid_date)
        expect(also_invalid_log).to_not be_valid
        expect(also_invalid_log.errors[:date]).to match_array([ "Date must fall between the gauge\'s start and end date" ])

        valid_log = FactoryBot.build(:gauge_log, gauge: gauge, date: valid_date)
        expect(valid_log).to be_valid
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
