module Api
  module Endpoint
    class Users < Api::Base
      resources :users do
        before do
          authorized!
          permission_denied!(User, :manage)
        end

        desc 'Get list of users'
        get do
          present User.all, with: Api::Entity::User
        end

        desc 'Create new user'
        params do
          requires :user, type: Hash do
            requires :email, type: String
            requires :password, type: String
            optional :first_name, type: String
            optional :last_name, type: String
          end
        end

        post do
          user = ::User.create!(params[:user].merge(user_id: current_user))

          present user, with: Api::Entity::User
        end

        desc 'Update user'
        params do
          requires :id, type: Integer
          requires :user, type: Hash do
            optional :email, type: String
            optional :password, type: String
            optional :first_name, type: String
            optional :last_name, type: String
          end
        end

        put ':id' do
          user = ::User.find(params[:id])
          user.update!(params[:user])

          present user, with: Api::Entity::User
        end

        desc 'Destroy user'
        params do
          requires :id, type: Integer
        end

        delete ':id' do
          user = ::User.find(params[:id])
          user.destroy!

          { status: 'ok' }
        end
      end
    end
  end
end