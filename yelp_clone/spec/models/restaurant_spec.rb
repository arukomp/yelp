require 'spec_helper'
describe Restaurant, type: :model do
  it 'is not valid with a name of less that three characters' do
    restaurant = Restaurant.new(name: 'kf')
    expect(restaurant).to have(1).error_on(:name)
    expect(restaurant).not_to be_valid
  end

  it 'is not valid unless it has a unique name' do
    Restaurant.create(name: "Moe's Tavren")
    restaurant = Restaurant.new(name: "Moe's Tavren")
    expect(restaurant).to have(1).error_on(:name)
  end

  it 'cannot delete a restaurant you don\'t own' do
    user = User.create(email: 'hello@hello.com', password: 'something')
    other_user = User.create(email: 'something@hello.com', password: 'password')
    restaurant = Restaurant.create(name: 'KFC', user: user)
    expect(restaurant.destroy_with_user(other_user)).to eq false
  end

  describe 'reviews' do
    describe 'build_with_user' do
      let(:user) { User.create email: 'test@test.com' }
      let(:restaurant) { Restaurant.create name: 'Test' }
      let(:review_params) { { rating: 5, thoughts: 'yum'} }

      subject(:review) { restaurant.reviews.build_with_user(review_params, user) }

      it 'buildsa review' do
        expect(review).to be_a Review
      end

      it 'builds a review associated with the specified user' do
        expect(review.user).to eq user
      end
    end
  end
end
