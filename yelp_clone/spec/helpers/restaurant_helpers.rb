def sign_in(email: 'test@example.com', password: 'password')
  visit '/'
  click_link 'Sign in'
  fill_in 'Email', with: email
  fill_in 'Password', with: password
  click_button 'Log in'
end

def sign_out
  click_link 'Sign out'
end
