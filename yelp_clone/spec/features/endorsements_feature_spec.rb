require 'rails_helper'

feature 'endorsing reviews' do

  before do
    kfc = Restaurant.create(name: 'KFC')
    @first_review = kfc.reviews.create(rating: 3, thoughts: 'It was an abomination!')
    kfc.reviews.build(rating: 1, thoughts: 'Absolute garbage').save(validate: false)
    @second_review = Review.last
  end

  scenario 'a user can endorse a review, which updates the endorsement count' do
    visit '/restaurants'
    within "ul" do
      click_link 'Endorse', match: :first
    end
    expect(page).to have_content "👍 1"
  end

  scenario 'correct amounts of endorsements are displayed for different reviews' do
    visit '/restaurants'
    within all('li').first do
      8.times { click_link 'Endorse' }
    end
    expect(page).to have_content "👍 8"
    within all('li').last do
      5.times { click_link 'Endorse' }
    end
    expect(page).to have_content "👍 5"
  end

end
