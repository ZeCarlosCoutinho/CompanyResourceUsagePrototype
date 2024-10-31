require 'rails_helper'

RSpec.describe 'User' do
  describe 'factory' do
    it 'generates an email' do
      user = FactoryBot.create(:user)
      expect(user.email).to match(/test\d+@example.com/)
    end

    it 'generates a hardcoded password' do
      user = FactoryBot.create(:user)
      expect(user.password).to match('testpassword')
    end

    it 'generates a valid user' do
      expect(FactoryBot.create(:user)).to be_valid
    end

    it 'generates a different email per user' do
      user1 = FactoryBot.create(:user)
      user2 = FactoryBot.create(:user)

      expect(user1.email).not_to eq(user2.email)
    end
  end
end