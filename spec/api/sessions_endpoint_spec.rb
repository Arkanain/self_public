require 'rails_helper'

describe Api::Endpoint::Sessions do
  def app
    Api::Base
  end

  let(:admin) { create(:admin) }

  it 'should return valid auth_token for admin' do
    post 'api/sessions', { email: admin.email, password: admin.password }

    expect(response.successful?).to be_truthy
    expect(body['auth_token']).to eq(admin.authentication_token)
  end

  it 'should not return auth_token for user with empty email or password' do
    post 'api/sessions', { email: '', password: '' }

    expect(response.client_error?).to be_truthy
  end

  it 'should not return auth_token with invalid email' do
    post 'api/sessions', { email: 'admin_test@email', password: admin.password }

    expect(response.client_error?).to be_truthy
  end

  it 'should sign_out user via auth token' do
    delete 'api/sessions', { auth_token: admin.authentication_token }

    expect(response.successful?).to be_truthy
  end
end