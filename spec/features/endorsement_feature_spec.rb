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

  scenario 'a user can endorse a review, which updates the review endorsement count' do
    visit '/restaurants'
    click_link 'Endorse Review'
    expect(page).to have_content('1 endorsement')
  end
end