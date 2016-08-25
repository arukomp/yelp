require 'rails_helper'


feature 'restaurants' do

  let!(:user) { User.create email: 'test@example.com', password: 'something' }
  let!(:second_user) { User.create email: 'anotherOne@gmail.com', password: 'password' }

  before do
    visit '/users/sign_up'
    fill_in 'Email', with: 'KFC@chicken.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_button 'Sign up'
  end

  context 'no restaurants have been added' do
    scenario 'should display a prompt to add restaurants' do
      visit '/restaurants'
      expect(page).to have_content 'No restaurants yet'
      expect(page).to have_link 'Add a restaurant'
    end
  end

  context 'restaurants have been added' do
    before do
      Restaurant.create(name: 'KFC')
    end

    scenario 'displays restaurants' do
      visit '/restaurants'
      expect(page).to have_content('KFC')
      expect(page).not_to have_content('No restaurants yet')
    end
  end

  context 'creating restaurants' do

    scenario 'prompt user to fill out a form, then displays the new restaurant' do
      visit '/restaurants'
      click_link 'Add a restaurant'
      fill_in 'Name',  with: 'KFC'
      click_button 'Create Restaurant'
      expect(page).to have_content 'KFC'
      expect(current_path).to eq '/restaurants'
    end

  end

  context 'an invalid restaurant' do
    scenario 'does not let you submit a name that is too short' do
      visit '/restaurants'
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'kf'
      click_button 'Create Restaurant'
      expect(page).not_to have_css 'h2', text: 'kf'
      expect(page).to have_content 'error'
    end
  end

  context 'viewing restaurants' do
    let!(:kfc){ Restaurant.create(name:'KFC', description: 'Filthiest chicken money can buy!') }

    scenario 'lets a user view a restaurant' do
      visit '/restaurants'
      click_link 'KFC'
      expect(page).to have_content 'KFC'
      expect(page).to have_content 'Filthiest chicken money can buy!'
      expect(current_path).to eq "/restaurants/#{kfc.id}"
    end
  end

  context 'editing restaurants' do
    before { Restaurant.create name: 'KFC', description: 'Deep fried goodness', user: user }

    scenario 'let user edit a restaurant' do
      sign_out
      sign_in(email: 'test@example.com', password: 'something')
      visit '/restaurants'
      click_link 'Edit KFC'
      fill_in 'Name', with: 'Kentucky Fried Chicken'
      fill_in 'Description', with: 'Deep fried goodness'
      click_button 'Update Restaurant'
      expect(page).to have_content 'Kentucky Fried Chicken'
      expect(page).to have_content 'Deep fried goodness'
      expect(current_path).to eq '/restaurants'
    end

    scenario 'cannot edit restaurant you don\'t own' do
      sign_out
      sign_in(email: 'anotherOne@gmail.com', password: 'password')
      visit '/restaurants'
      click_link 'Edit KFC'
      expect(page).to have_content 'Cannot edit a restaurant you don\'t own'
    end
  end

  context 'deleting restaurants' do

    before { Restaurant.create name: 'KFC', description: 'Deep fried goodness', user: user }

    scenario 'removes a restaurant when a user clicks a delete link' do
      sign_out
      sign_in(email: 'test@example.com', password: 'something')
      visit '/restaurants'
      click_link 'Delete KFC'
      expect(page).not_to have_content 'KFC'
      expect(page).to have_content 'Restaurant deleted successfully'
    end

    scenario 'does not allow deleting a different user\'s restaurant' do
      sign_out
      sign_in(email: 'anotherOne@gmail.com', password: 'password')
      visit '/restaurants'
      click_link 'Delete KFC'
      expect(page).to have_content 'KFC'
      expect(page).to have_content 'Cannot delete a restaurant you don\'t own'
    end

  end

end
