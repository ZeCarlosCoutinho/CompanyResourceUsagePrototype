require 'rails_helper'

RSpec.describe "Navigation", type: :system do
  before do
    driven_by(:rack_test)
  end

  subject { FactoryBot.create(:profile).user }
  before(:each) { sign_in(subject) }

  context 'when I am in the gauges list page' do
    it 'allows me to log out' do
      visit "/gauge/index"

      expect(page).to have_button("Log out")
      expect { click_button "Log out" }.to change(page, :current_path).to("/users/sign_in")
    end
  end

  context 'when I am in the create gauge page' do
    it 'allows me to go back to the gauge list' do
      visit "/gauge/new"

      expect(page).to have_link("Back")
      expect { click_link "Back" }.to change(page, :current_path).to("/gauge/index")
    end
  end
end