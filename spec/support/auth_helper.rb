module Support
  module AuthHelper
    attr_reader :auth_token

    def api_sign_in(user)
      post '/api/sessions', { email: user.email, password: user.password }

      @auth_token = JSON.parse(last_response.body)['auth_token']
    end
  end
end