module Api
  class Base < Grape::API
    helpers Api::Helpers

    prefix 'api'
    default_format :json
    format :json
    formatter :json, Grape::Formatter::ActiveModelSerializers

    # Using param means that we will include version of api into path after prefix
    # Example below will create route like 'api/v1':
    # version 'v1', using: :path

    before do
      authenticated
    end

    mount Api::Endpoint::Sessions
    mount Api::Endpoint::Articles
    mount Api::Endpoint::Users
  end
end