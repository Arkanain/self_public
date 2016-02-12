module Support
  module AuthHelper
    attr_reader :auth_token

    def api_sign_in(user)
      post '/api/sessions', { email: user.email, password: user.password }

      @auth_token = JSON.parse(last_response.body)['auth_token']
    end

    def capybara_sign_in(user)
      visit new_user_session_path

      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button 'Log in'
    end
  end
end