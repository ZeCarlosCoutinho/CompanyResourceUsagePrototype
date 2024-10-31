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
  end
end