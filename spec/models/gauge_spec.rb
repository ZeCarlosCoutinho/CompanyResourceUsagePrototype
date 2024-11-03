require 'rails_helper'

RSpec.describe Gauge, type: :model do
  describe 'factory' do
    it 'generates a valid gauge' do
      expect(FactoryBot.create(:gauge)).to be_valid
    end
  end

  describe 'validations' do
    # TODO Validate that none of the fields can be null
    # TODO Validate that the time_slots have to be one of the enums

    describe 'end_date' do
      let(:start_date) { 1.month.ago }
      let(:valid_end_date) { Date.today }
      let(:also_valid_end_date) { start_date }
      let(:invalid_end_date) { 2.months.ago }

      it 'must be the same or after the start_date' do
        valid_gauge1 = FactoryBot.build(:gauge, start_date: start_date, end_date: valid_end_date)
        expect(valid_gauge1).to be_valid

        valid_gauge2 = FactoryBot.build(:gauge, start_date: start_date, end_date: also_valid_end_date)
        expect(valid_gauge2).to be_valid

        invalid_gauge = FactoryBot.build(:gauge, start_date: start_date, end_date: invalid_end_date)
        expect(invalid_gauge).to_not be_valid
        expect { invalid_gauge.save! }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
