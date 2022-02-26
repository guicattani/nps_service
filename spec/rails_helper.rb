# frozen_string_literal: true

require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

require 'simplecov'
require 'factory_bot_rails'
require 'shoulda/matchers'
require 'database_cleaner'

SimpleCov.start 'rails' do
  # Since the workers use Sneakers we won't get any coverage reported even if it gets called
  add_filter %r{^/app/worker}
end

Dir[Rails.root.join('spec/support/publishers/**/*.rb')].each { |f| require f }
Dir[Rails.root.join('spec/support/helpers/**/*.rb')].each { |f| require f }
Dir[Rails.root.join('spec/support/shared/*.rb')].each { |f| require f }

# load seeds
Dir[Rails.root.join('spec/seeds/**/*.seeds.rb')].each do |seed|
  load seed
end

RSpec.configure do |config|
  config.include(Shoulda::Matchers::ActiveModel, type: :model)
  config.include(Shoulda::Matchers::ActiveRecord, type: :model)

  config.include AuthRequestHelper, type: :request
  config.include AuthHelper, type: :controller

  config.filter_run :focus
  config.filter_rails_from_backtrace!
  config.infer_spec_type_from_file_location!
  config.run_all_when_everything_filtered = true
  config.use_transactional_fixtures = false

  config.before(:suite) do
    conn = Bunny.new
    conn.start
    channel = conn.create_channel
    exchange = Bunny::Exchange.new(channel,
                                   :direct,
                                   "#{ENV['BUNNY_AMQP_EXCHANGE']}_test",
                                   { durable: true })

    queue = Bunny::Queue.new(channel,
                             "#{ENV['CREATE_NPS_QUEUE_NAME']}_test",
                             { durable: true })
    queue.bind(exchange, routing_key: "#{ENV['CREATE_NPS_QUEUE_NAME']}_test")
    conn.close

    # The :transaction strategy prevents :after_commit hooks from running
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.after(:suite) do
    conn = Bunny.new
    conn.start
    channel = conn.create_channel

    # Main
    exchange = Bunny::Exchange.new(channel, :direct, "#{ENV['BUNNY_AMQP_EXCHANGE']}_test",
                                   { durable: true })
    queue = Bunny::Queue.new(channel, "#{ENV['CREATE_NPS_QUEUE_NAME']}_test", { durable: true })
    queue.unbind(exchange, routing_key: "#{ENV['CREATE_NPS_QUEUE_NAME']}_test")
    queue.delete
    exchange.delete

    # Error
    exchange = Bunny::Exchange.new(channel, :topic, "#{ENV['BUNNY_AMQP_EXCHANGE']}_test-error", { durable: true })
    queue = Bunny::Queue.new(channel, "#{ENV['CREATE_NPS_QUEUE_NAME']}_test-error", { durable: true })
    queue.unbind(exchange, routing_key: "#{ENV['CREATE_NPS_QUEUE_NAME']}_test-error")
    queue.delete
    exchange.delete
  end
end
