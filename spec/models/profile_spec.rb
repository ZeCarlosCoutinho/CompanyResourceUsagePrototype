require 'rails_helper'

RSpec.describe 'Profile' do
  describe 'factory' do
    it 'generates a valid profile' do
      expect(FactoryBot.create(:profile)).to be_valid
    end
  end

  describe 'validations' do
    describe 'name' do
      it 'is not an empty string' do
        pending
      end

      it 'is not null' do
        pending
      end
    end

    describe 'is_manager' do
      it 'is not null' do
        pending
      end
    end

    describe 'user' do
      it 'is not null' do
        pending
      end
      
      it 'is unique' do
        pending
      end
    end
  end

    # Must have a name
  # Name must have 1 or more strings
  # Must have a is_manager
  # Must have an associated user
end