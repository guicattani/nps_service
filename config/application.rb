require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module NpsService
  class Application < Rails::Application
    config.load_defaults 7.0
    config.debug_exception_response_format = :api
    config.api_only = true

    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
