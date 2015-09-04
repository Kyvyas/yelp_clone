require 'rails_helper'

feature 'endorsing reviews' do
  before(:each) do
      user = build :user
      sign_up(user)
      visit '/restaurants/new'
      fill_in 'Name', with: 'KFC'
      click_button 'Create Restaurant'
      visit '/restaurants'
      click_link 'Review KFC'
      fill_in "Thoughts", with: "It was an abomination"
      select '3', from: 'Rating'
      click_button 'Leave Review'
    end

  it 'a user can endorse a review, which increments the endorsement count', js: true do
    visit '/restaurants'
    click_link 'Endorse'
    expect(page).to have_content("1 endorsement")
  end
end