
feature 'reviewing' do

  before do
    visit '/users/sign_up'
    fill_in 'Email', with: 'KFC@chicken.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_button 'Sign up'
  end

  before { Restaurant.create name: 'KFC'}

  context 'has a review' do

    before do
      visit '/restaurants'
      click_link 'Review KFC'
      fill_in "Thoughts", with: "Love chicken"
      select '5', from: 'Rating'
      click_button 'Leave Review'
    end

    scenario 'allows users to leave a review using a form' do
      expect(page).to have_content('Love chicken')
      expect(current_path).to eq '/restaurants'
    end

    scenario 'allows user to delete a review' do
      visit '/restaurants'
      click_link 'Delete review'
      expect(page).to have_content 'Review has been deleted'
      expect(page).to_not have_content 'Love chicken'
    end

    scenario 'does not allow the user to delete other user\'s review' do
      
    end

  end
end
