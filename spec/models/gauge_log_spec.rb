require 'rails_helper'

RSpec.describe GaugeLog, type: :model do
  describe 'factory' do
    it 'generates a valid gauge' do
      expect(FactoryBot.create(:gauge_log)).to be_valid
    end
  end
end
