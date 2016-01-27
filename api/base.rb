module Api
  class Base < Grape::API
    helpers Api::Helpers

    prefix 'api'
    default_format :json
    format :json

    # Using param means that we will include version of api into path after prefix
    # Example below will create route like 'api/v1':
    # version 'v1', using: :path

    before do
      header 'Access-Control-Allow-Origin', '*'
      header 'Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE'
      header 'Access-Control-Allow-Headers', 'Accept, X-Requested-With, Content-Type'

      current_user
    end

    mount Api::Endpoint::Sessions
    mount Api::Endpoint::Articles
    mount Api::Endpoint::Users
  end
end