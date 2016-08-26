require 'rails_helper'
require 'web_helper'

feature 'restaurants' do

  context 'user not signed in' do
    scenario 'cannot create restaurant' do
      visit '/'
      click_link 'Add a restaurant'
      expect(page).to have_content 'Log in'
    end
  end

  context 'no restaurants have been added' do
    scenario 'should display a prompt to add a restaurant' do
      sign_up
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
      sign_up
      visit '/restaurants'
      expect(page).to have_content('KFC')
      expect(page).not_to have_content('No restaurants yet')
    end
  end

  context 'creating restaurants' do

    scenario 'prompts user to fill out a form, then display the new restaurant' do
      sign_up
      create_restaurant
      expect(page).to have_content 'KFC'
      expect(current_path).to eq '/restaurants'
    end

    context 'an invalid restaurant' do
      scenario 'does not let you submit a name that is too short' do
        sign_up
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
    let!(:kfc) { Restaurant.create(name: 'KFC') }
    scenario 'lets a user view a restaurant' do
      sign_up
      visit '/restaurants'
      click_link 'KFC'
      expect(page).to have_content 'KFC'
      expect(current_path).to eq "/restaurants/#{kfc.id}"
    end
  end

  context 'editing restaurants' do
    before do
      sign_up
      create_restaurant
    end

    scenario 'let a user edit a restaurant' do
      visit '/restaurants'
      click_link 'Edit KFC'
      fill_in 'Name', with: 'Kentucky Fried Chicken'
      fill_in 'Description', with: 'Deep fried goodness'
      click_button 'Update Restaurant'
      expect(page).to have_content 'Kentucky Fried Chicken'
      expect(page).to have_content 'Deep fried goodness'
      expect(current_path).to eq '/restaurants'
    end

    scenario 'user cannot edit someone else\'s restaurant' do
      click_link 'Sign out'
      sign_up(email: 'another@user.com')
      click_link 'Edit KFC'
      expect(page).to have_content 'Cannot edit someone else\'s restaurant'
    end
  end

  context 'deleting restaurants' do
    before do
      sign_up
      create_restaurant
    end

    scenario 'removes a restaurant when a user clicks a delete link' do
      visit '/restaurants'
      click_link 'Delete KFC'
      expect(page).not_to have_content 'KFC'
      expect(page).to have_content 'Restaurant deleted successfully'
    end

    scenario 'cannot delete restaurant that belongs to another user' do
      sign_out
      sign_up(email: 'alex@gmail.com')
      click_link 'Delete KFC'
      expect(page).to have_content 'Cannot delete someone else\'s restaurant'
    end
  end


end
