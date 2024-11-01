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
        invalid_profile = FactoryBot.build(:profile, name: '')
        expect(invalid_profile.name).to eq('')
        expect(invalid_profile).to_not be_valid
        expect { invalid_profile.save! }.to raise_error(ActiveRecord::RecordInvalid)

        valid_profile = FactoryBot.build(:profile, name: 'valid name')
        expect(valid_profile).to be_valid
        expect { valid_profile.save! }.to_not raise_error
      end

      it 'should not be null' do
        invalid_profile = FactoryBot.build(:profile, name: nil)
        expect(invalid_profile.name).to be_nil
        expect(invalid_profile).to_not be_valid
        expect { invalid_profile.save! }.to raise_error(ActiveRecord::RecordInvalid)

        valid_profile = FactoryBot.build(:profile, name: 'valid name')
        expect(valid_profile).to be_valid
        expect { valid_profile.save! }.to_not raise_error
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