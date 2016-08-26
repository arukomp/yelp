require 'rails_helper'

feature 'reviewing' do
  before do
    Restaurant.create name: 'KFC'
    sign_up
    visit '/restaurants'
    click_link 'Review KFC'
    fill_in "Thoughts", with: "so so"
    select '3', from: 'Rating'
    click_button 'Leave Review'
  end

  scenario 'allows users to leave a review using a form' do
    expect(current_path).to eq '/restaurants'
    expect(page).to have_content('so so')
  end

  scenario 'user can only review restaurant once' do
    click_link 'Review KFC'
    expect(page).to have_content('You have already reviewed this restaurant')
  end
end
