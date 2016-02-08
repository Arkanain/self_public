module Support
  module Parser
    def body
      JSON.parse(last_response.body)
    end
  end
end