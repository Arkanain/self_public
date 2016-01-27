module Api
  module Endpoint
    class Sessions < Api::Base
      resource :sessions do
        desc 'Auth user and return user object and auth token'
        params do
          requires :email, type: String
          requires :password, type: String
        end

        post do
          email = params[:email]
          password = params[:password]

          error!('Invalid Email or Password.', 401) if email.nil? or password.nil?

          user = User.where(email: email.downcase).first

          error!('Invalid Email or Password', 401) if user.nil?

          if user.valid_password?(password)
            user.ensure_authentication_token!
            user.save

            { status: 'ok', auth_token: user.authentication_token }
          else
            error!('Invalid Email or Password.', 401, headers)
          end
        end

        desc 'Destroy auth token'
        params do
          requires :auth_token, type: String
        end

        delete do
          auth_token = params[:auth_token]
          user = User.where(authentication_token: auth_token).first

          user.reset_authentication_token
          { status: 'ok' }
        end
      end
    end
  end
end