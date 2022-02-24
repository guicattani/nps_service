source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.1"

# Core
gem "rails", "~> 7.0.2", ">= 7.0.2.2"
gem "pg", "~> 1.1"
gem "puma", "~> 5.0"
gem "bootsnap", require: false

# Windows build
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# ActiveRecord
gem 'activerecord-pg_enum'

# ActiveJob queueing
gem 'good_job'

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'rubocop', '~> 1.1'
  gem 'rubocop-daemon', require: false
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
  gem 'pry-byebug'
end

group :development do
  gem 'guard-rspec', require: false
  gem 'rusky'
  gem 'spring'
  gem 'spring-commands-rspec'
end

group :test do
  gem 'database_cleaner'
  gem 'rspec-rails'
  gem 'shoulda-matchers', require: false
  gem 'simplecov'
  gem 'u-case'
end

