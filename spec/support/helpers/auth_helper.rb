# frozen_string_literal: true

module AuthHelper
  def http_login
    username = ENV['HTTP_BASIC_AUTH_USER']
    password = ENV['HTTP_BASIC_AUTH_PASSWORD']
    request.headers['AUTHORIZATION'] =
      ActionController::HttpAuthentication::Basic.encode_credentials(username, password)
  end
end

module AuthRequestHelper
  #
  # pass the @env along with your request, eg:
  #
  # GET '/labels', {}, @env
  #
  def http_login
    @headers ||= {}
    user = ENV['HTTP_BASIC_AUTH_USER']
    pw = ENV['HTTP_BASIC_AUTH_PASSWORD']
    @headers['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user, pw)
  end
end
