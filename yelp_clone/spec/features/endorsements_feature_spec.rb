require 'rails_helper'

feature 'endorsing reviews' do

  before do
    kfc = Restaurant.create(name: 'KFC')
    kfc.reviews.create(rating: 3, thoughts: 'It was an abomination!')
  end

  scenario 'a user can endorse a review, which updates the endorsement count' do
    visit '/restaurants'
    click_link 'Endorse'
    expect(page).to have_content '👍 1'
  end

end
