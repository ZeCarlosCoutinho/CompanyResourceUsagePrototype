require 'rails_helper'

RSpec.describe Gauge, type: :model do
  describe 'factory' do
    it 'generates a valid gauge' do
      expect(FactoryBot.create(:gauge)).to be_valid
    end
  end

  describe 'validations' do
    # TODO Validate that none of the fields can be null
    # TODO Validate that start date is always equal or before the end date
    # TODO Validate that the time_slots have to be one of the enums
    pending
  end
end
