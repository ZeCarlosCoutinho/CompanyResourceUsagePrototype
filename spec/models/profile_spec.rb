require 'rails_helper'

RSpec.describe 'Profile' do
  describe 'factory' do
    it 'generates a valid profile' do
      expect(FactoryBot.create(:profile)).to be_valid
    end

    describe 'employee' do
      it 'generates a profile of an employee' do
        expect(FactoryBot.create(:employee).is_manager).to eq(false)
      end
    end

    describe 'manager' do
      it 'generates a profile of a manager' do
        expect(FactoryBot.create(:manager).is_manager).to eq(true)
      end
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
        invalid_profile = FactoryBot.build(:profile, is_manager: nil)
        expect(invalid_profile).to_not be_valid
        expect { invalid_profile.save! }.to raise_error(ActiveRecord::RecordInvalid)

        valid_profile = FactoryBot.build(:profile, is_manager: false)
        expect(valid_profile).to be_valid
        expect { valid_profile.save! }.to_not raise_error
      end
    end

describe 'user' do
      it 'is not null' do
        invalid_profile = FactoryBot.build(:profile, user: nil)
        expect(invalid_profile).to_not be_valid
        expect { invalid_profile.save! }.to raise_error(ActiveRecord::RecordInvalid)

        valid_profile = FactoryBot.build(:profile)
        expect(valid_profile).to be_valid
        expect { valid_profile.save! }.to_not raise_error
      end

      it 'is unique' do
        user1 = FactoryBot.create(:user)

        valid_profile = FactoryBot.build(:profile, user: user1)
        expect(valid_profile).to be_valid
        expect { valid_profile.save! }.to_not raise_error

        invalid_profile = FactoryBot.build(:profile, user: user1)
        expect(invalid_profile).to_not be_valid
        expect { invalid_profile.save! }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  describe '#is_employee?' do
    context 'when the profile is a employee' do
      let(:employee) { FactoryBot.create(:employee) }

      it 'returns true' do
        expect(employee.is_employee?).to eq(true)
      end
    end

    context 'when the profile is a manager' do
      let(:manager) { FactoryBot.create(:manager) }

      it 'returns false' do
        expect(manager.is_employee?).to eq(false)
      end
    end
  end

  # TODO Should be deleted if the associated user is deleted
  # TODO Should delete the user if the profile is deleted
end
