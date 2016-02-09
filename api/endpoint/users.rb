module Api
  module Endpoint
    class Users < Api::Base
      resources :users do
        before do
          authorized!
        end

        desc 'Get list of users'
        get do
          permission_denied!(User, :index)

          present ::User.all, with: Api::Entity::User
        end

        desc 'Return current user object'
        get 'current_user' do
          permission_denied!(current_user, :show)

          present current_user, with: Api::Entity::User
        end

        desc 'Create new user'
        params do
          requires :role, type: String
          requires :email, type: String
          requires :password, type: String
          requires :password_confirmation, type: String
          optional :first_name, type: String
          optional :last_name, type: String
        end

        post do
          permission_denied!(User, :create)

          user = ::User.create!(permitted_attributes!(Api::Entity::User))

          present user, with: Api::Entity::User
        end

        desc 'Get single user'
        params do
          requires :id, type: Integer
        end

        get ':id' do
          user = ::User.find(params[:id])

          permission_denied!(user, :show)

          present user, with: Api::Entity::User
        end

        desc 'Update user'
        params do
          requires :id, type: Integer
          optional :role, type: String
          optional :email, type: String
          optional :password, type: String
          optional :password_confirmation, type: String
          optional :first_name, type: String
          optional :last_name, type: String
        end

        put ':id' do
          user = ::User.find(params[:id])

          permission_denied!(user, :update)

          user.update!(permitted_attributes!(Api::Entity::User))

          present user, with: Api::Entity::User
        end

        desc 'Destroy user'
        params do
          requires :id, type: Integer
        end

        delete ':id' do
          user = ::User.find(params[:id])

          permission_denied!(user, :destroy)

          user.destroy!

          { status: 'ok' }
        end
      end
    end
  end
end