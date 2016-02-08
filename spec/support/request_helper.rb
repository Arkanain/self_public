module Support
  module RequestHelper
    class_eval do
      [:get, :post, :put, :delete].each do |method|
        define_method(method) do |uri, params={}|
          uri += "?auth_token=#{auth_token}" if auth_token
          super(uri, params)
        end
      end
    end

    def response
      last_response
    end
  end
end