require 'rails_helper'

RSpec.describe Gauge, type: :model do
  describe 'factory' do
    it 'generates a valid gauge' do
      expect(FactoryBot.create(:gauge)).to be_valid
    end
  end
end
