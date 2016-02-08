module Support
  module Parser
    def body
      JSON.parse(last_response.body)
    end
  end
end

# [:empty?,
#  :invalid?,
#  :informational?,
#  :successful?,
#  :redirection?,
#  :client_error?,
#  :server_error?,
#  :ok?,
#  :bad_request?,
#  :forbidden?,
#  :not_found?,
#  :method_not_allowed?,
#  :unprocessable?,
#  :redirect?]