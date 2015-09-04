require 'rails_helper'

feature 'reviewing' do

	before(:each) do
		visit '/users/sign_up'
    fill_in 'Email', with: 'Katya@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_button 'Sign up'
    visit '/restaurants/new'
    fill_in 'Name', with: 'KFC'
    click_button 'Create Restaurant'
  end

	scenario 'allows users to leave a review using a form' do
		visit '/restaurants'
		click_link 'Review KFC'
		fill_in "Thoughts", with: "so so"
		select '3', from: 'Rating'
		click_button 'Leave Review'
		expect(current_path).to eq '/restaurants'
		expect(page).to have_content('so so')
	end

	scenario 'users can only review a restaurant once' do
		visit '/restaurants'
		click_link 'Review KFC'
		fill_in "Thoughts", with: "so so"
		select '3', from: 'Rating'
		click_button 'Leave Review'
		visit '/restaurants'
		click_link 'Review KFC'
		fill_in "Thoughts", with: "wonderful"
		select '3', from: 'Rating'
		click_button 'Leave Review'
		expect(page).to have_content('You have already reviewed this restaurant')
	end

	scenario 'reviews can be deleted if current user created them' do
		visit '/restaurants'
		click_link 'Review KFC'
		fill_in "Thoughts", with: "so so"
		select '3', from: 'Rating'
		click_button 'Leave Review'
		click_link 'Delete review'
		expect(page).not_to have_content 'so so'
	end

	scenario 'reviews cannot be deleted if current user created them' do
		visit '/restaurants'
		click_link 'Review KFC'
		fill_in "Thoughts", with: "so so"
		select '3', from: 'Rating'
		click_button 'Leave Review'
		visit '/'
    click_link 'Sign out'
    visit '/users/sign_up'
    fill_in 'Email', with: 'Hello@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_button 'Sign up'
		visit '/restaurants'
		click_link 'Delete review'
		expect(page).to have_content 'You did not write this review'
	end

	scenario 'reviews show user email of person who has reviewed' do
		visit '/restaurants'
		click_link 'Review KFC'
		fill_in "Thoughts", with: "so so"
		select '3', from: 'Rating'
		click_button 'Leave Review'
		expect(page).to have_content 'katya@test.com'
		expect(page).to have_link 'Delete review'
	end

	scenario 'displays an average rating for all reviews' do
		user_2 = build(:user_2)
		leave_review('not good', 3)
		click_link 'Sign out'
		sign_up(user_2)
		leave_review('Great', 5)
		expect(page).to have_content 'Average rating: 4'
	end
end