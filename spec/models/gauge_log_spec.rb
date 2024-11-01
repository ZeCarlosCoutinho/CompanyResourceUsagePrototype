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
end
