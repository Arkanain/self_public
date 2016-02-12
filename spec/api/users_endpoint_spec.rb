require 'rails_helper'

describe Api::Endpoint::Users do
  def app
    Api::Base
  end

  let(:admin) { create(:admin) }
  let(:writer) { create(:writer) }
  let(:new_user_params) { attributes_for(:writer) }

  context 'as guest' do
    it 'should not get list of users' do
      get 'api/users'

      expect(response.client_error?).to be_truthy
    end

    it 'should not get single user' do
      get "api/users/#{writer.id}"

      expect(response.client_error?).to be_truthy
    end

    it 'should not get current_user' do
      get 'api/users/current_user'

      expect(response.client_error?).to be_truthy
    end

    it 'should not create new user' do
      post 'api/users', new_user_params

      expect(response.client_error?).to be_truthy
    end

    it 'should not update single user' do
      put "api/users/#{writer.id}", new_user_params

      expect(response.client_error?).to be_truthy
    end

    it 'should not delete single user' do
      delete "api/users/#{writer.id}"

      expect(response.client_error?).to be_truthy
    end
  end

  context 'as admin' do
    before(:each) do
      api_sign_in(admin)
    end

    it 'should get list of users' do
      2.times { create(:writer) }

      get 'api/users'

      expect(response.successful?).to be_truthy
      expect(body.length).to eq(3)
    end

    it 'should get single user' do
      get "api/users/#{writer.id}"

      expect(response.successful?).to be_truthy
      expect(body['first_name']).to eq(writer.first_name)
    end

    it 'should get current_user' do
      get 'api/users/current_user'

      expect(response.successful?).to be_truthy
      expect(body['first_name']).to eq(admin.first_name)
    end

    it 'should create new user' do
      post 'api/users', new_user_params

      expect(response.successful?).to be_truthy
      expect(body['first_name']).to eq(new_user_params[:first_name])
    end

    it 'should update single user' do
      put "api/users/#{writer.id}", new_user_params

      expect(response.successful?).to be_truthy
      expect(body['first_name']).to eq(new_user_params[:first_name])
    end

    it 'should delete single user' do
      delete "api/users/#{writer.id}"

      expect(response.successful?).to be_truthy
    end

    it 'should not delete current_user' do
      delete "api/users/#{admin.id}"

      expect(response.server_error?).to be_truthy
    end
  end

  context 'as writer' do
    before(:each) do
      api_sign_in(writer)
    end

    it 'should not get list of users' do
      get 'api/users'

      expect(response.server_error?).to be_truthy
    end

    it 'should not get single user' do
      get "api/users/#{admin.id}"

      expect(response.server_error?).to be_truthy
    end

    it 'should get current_user' do
      get 'api/users/current_user'

      expect(response.successful?).to be_truthy
      expect(body['first_name']).to eq(writer.first_name)
    end

    it 'should not create new user' do
      post 'api/users', new_user_params

      expect(response.server_error?).to be_truthy
    end

    it 'should update his own user' do
      put "api/users/#{writer.id}", new_user_params

      expect(response.successful?).to be_truthy
      expect(body['first_name']).to eq(new_user_params[:first_name])
    end

    it 'should not update single user' do
      put "api/users/#{admin.id}", new_user_params

      expect(response.server_error?).to be_truthy
    end

    it 'should not delete single user' do
      delete "api/users/#{admin.id}"

      expect(response.server_error?).to be_truthy
    end
  end
end