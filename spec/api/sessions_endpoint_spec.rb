require 'rails_helper'

describe Api::Endpoint::Sessions, type: :rack do
  def app
    Api::Base
  end

  let(:admin) { create(:admin) }

  context 'as admin' do
    it 'should return valid auth_token for admin' do
      post '/api/sessions', { email: admin.email, password: admin.password }

      expect(body['auth_token']).to eq(admin.authentication_token)
    end
  end
end