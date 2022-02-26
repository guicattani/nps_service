# frozen_string_literal: true

def parsed_response
  JSON.parse(response.body)
end
