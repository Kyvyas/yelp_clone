require 'rails_helper'

feature 'restaurants' do
  context 'no restaurants have been added' do
    scenario 'should display a prompt to add restaurant' do
      visit '/restaurants'
      expect(page).to have_content 'No restaurants yet'
      expect(page).to have_link 'Add a restaurant'
    end
  end

  context 'restaurants have been added' do
	  before do
	    Restaurant.create(name: 'KFC')
	  end

	  scenario 'display restaurants' do
	    visit '/restaurants'
	    expect(page).to have_content('KFC')
	    expect(page).not_to have_content('No restaurants yet')
	  end
	end

  context 'creating restaurants' do
    scenario 'prompt user to fill out a form, then displays the new restaurant' do
      user = build :user
      sign_up(user)
      visit '/restaurants/new'
      fill_in 'Name', with: 'KFC'
      click_button 'Create Restaurant'
      expect(page).to have_content 'KFC'
      expect(current_path).to eq '/restaurants'
    end

    scenario 'user can upload image of restaurant' do
      user = build :user
      sign_up(user)
      visit '/restaurants/new'
      fill_in 'Name', with: 'KFC'
      attach_file("restaurant[image]", "spec/assets_specs/photos/KFC.jpg")
      click_button 'Create Restaurant'
      expect(page).to have_selector 'img'
      # expect(page.find('.RestaurantImage')['src']).to have_content 'KFC.jpg'
      # expect(page).to have_xpath("//img[@src='/spec/assets_specs/photos/KFC.jpg?1441369740']")
    end

     scenario 'image does not display if no image uploaded' do
      user = build :user
      sign_up(user)
      visit '/restaurants/new'
      fill_in 'Name', with: 'KFC'
      # attach_file("restaurant[image]", "spec/assets_specs/photos/KFC.jpg")
      click_button 'Create Restaurant'
      expect(page).not_to have_selector 'img'
      # expect(page.find('.RestaurantImage')['src']).to have_content 'KFC.jpg'
      # expect(page).to have_xpath("//img[@src='/spec/assets_specs/photos/KFC.jpg?1441369740']")
    end

    context 'an invalid restaurant' do
      it 'does not let you submit a name that is too short' do
        user = build :user
        sign_up(user)
        visit '/restaurants'
        click_link 'Add a restaurant'
        fill_in 'Name', with: 'kf'
        click_button 'Create Restaurant'
        expect(page).not_to have_css 'h2', text: 'kf'
        expect(page).to have_content 'error'
      end
    end
  end

  context 'viewing restaurants' do
    let!(:kfc){Restaurant.create(name:'KFC')}

    scenario 'lets a user view a restaurant' do
      user = build :user
      sign_up(user)
      visit '/restaurants'
      click_link 'KFC'
      expect(page).to have_content 'KFC'
      expect(current_path).to eq "/restaurants/#{kfc.id}"
    end
  end

  context 'editing restaurants' do

     before(:each) do
      user = build :user
      sign_up(user)
      visit '/restaurants/new'
      fill_in 'Name', with: 'KFC'
      click_button 'Create Restaurant'
    end

    scenario 'let a user edit a restuarant' do
      visit '/restaurants'
      click_link 'Edit KFC'
      fill_in 'Name', with: 'Kentucky Fried Chicken'
      click_button 'Update Restaurant'
      expect(page).to have_content 'Kentucky Fried Chicken'
      expect(current_path).to eq '/restaurants'
    end

    scenario 'user can only edit own restaurants' do
      visit '/'
      click_link 'Sign out'
      visit '/users/sign_up'
      fill_in 'Email', with: 'Hello@test.com'
      fill_in 'Password', with: '12345678'
      fill_in 'Password confirmation', with: '12345678'
      click_button 'Sign up'
      visit '/restaurants'
      expect(page).not_to have_link 'Edit KFC'
    end

  end

  context 'deleting restaurants' do

    before(:each) do
      user = build :user
      sign_up(user)
      visit '/restaurants/new'
      fill_in 'Name', with: 'KFC'
      click_button 'Create Restaurant'
    end

    scenario 'removes a restaurant when a user creates a delete link' do
      visit '/restaurants'
      click_link 'Delete KFC'
      expect(page).not_to have_content 'KFC'
      expect(page).to have_content 'Restaurant deleted successfully'
    end

    scenario 'user cannot delete restaurant if they did not create it' do
      user_2 = build(:user_2)
      visit '/'
      click_link 'Sign out'
      sign_up(user_2)
      visit '/restaurants'
      expect(page).not_to have_link('Delete KFC')
    end
  end
end