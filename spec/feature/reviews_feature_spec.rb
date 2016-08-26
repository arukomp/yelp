require 'rails_helper'

feature 'reviewing' do

  before do
    sign_up
    create_restaurant
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

  scenario 'user can delete a review' do
    click_link 'Delete review', match: :first
    expect(page).to have_content 'Review deleted successfully'
    expect(page).to_not have_content 'so so'
  end

  scenario 'user cannot delete a review that does not belong to him/her/it' do
    sign_out
    sign_up(email: 'different@google.com')
    click_link 'Delete review', match: :first
    expect(page).to have_content 'Cannot delete someone else\'s review'
    expect(page).to have_content 'so so'
  end
end
