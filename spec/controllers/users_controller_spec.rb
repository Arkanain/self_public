require 'rails_helper'

describe UsersController, type: :controller do
  let(:admin) { create(:admin) }
  let(:writer) { create(:writer) }

  context 'as guest' do
    it 'should not get list of users' do
      get :index

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'should not create new user' do
      post :create, user: attributes_for(:writer)

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'should not update user' do
      put :update, id: writer, user: { first_name: 'New First Name' }

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'should not delete user' do
      delete :destroy, id: writer

      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context 'as writer' do
    before(:each) do
      sign_in(:user, writer)
    end

    it 'should not get list of user' do
      get :index

      expect(response).to be_forbidden
    end

    it 'should not create new user' do
      new_user = attributes_for(:writer)
      post :create, user: new_user

      expect(response).to be_forbidden
    end

    it 'should update himself' do
      put :update, id: writer, user: { first_name: 'New First Name' }

      expect(assigns[:user].first_name).to eq('New First Name')
      expect(response).to redirect_to(user_path(writer))
    end

    it 'should not update other users' do
      put :update, id: admin, user: { first_name: 'New First Name' }

      expect(response).to be_forbidden
    end

    it 'should not delete user' do
      delete :destroy, id: writer, format: :js

      expect(response).to be_forbidden
    end
  end

  context 'as admin' do
    before(:each) do
      sign_in(:user, admin)
    end

    it 'should get list of users' do
      get :index

      expect(response).to render_template(:index)
      expect(assigns[:users].length).to eq(1)
    end

    it 'should create new user' do
      new_user = attributes_for(:writer)
      post :create, user: new_user

      expect(response).to redirect_to(user_path(assigns[:user]))
      expect(assigns[:user].first_name).to eq(new_user[:first_name])
    end

    it 'should update himself' do
      put :update, id: admin, user: { first_name: 'New First Name' }

      expect(response).to redirect_to(user_path(assigns[:user]))
      expect(assigns[:user].first_name).to eq('New First Name')
    end

    it 'should update user' do
      put :update, id: writer, user: { first_name: 'New First Name' }

      expect(response).to redirect_to(user_path(assigns[:user]))
      expect(assigns[:user].first_name).to eq('New First Name')
    end

    it 'should delete user' do
      delete :destroy, id: writer, format: :js

      expect(response).to be_success
      expect(User.count).to eq(1)
      expect(User.first.first_name).to eq(admin.first_name)
    end

    it 'should not delete himself' do
      delete :destroy, id: admin, format: :js

      expect(response).to be_forbidden
    end
  end
end