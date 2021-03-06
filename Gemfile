source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1.4', '>= 6.1.4.4'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'
# Use Puma as the app server
gem 'puma', '~> 5.0'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'
# template engine slim
gem 'slim-rails'
# Working with nested forms
gem 'cocoon'
# Simplifies the implementation of OAuth 2 provider features
gem 'doorkeeper'

gem 'active_model_serializers', '~> 0.10'
# A fast JSON parser
gem 'oj'

# Simple, efficient background processing for Ruby
gem 'sidekiq'
gem 'sinatra', require: false
# Provides syntax for writing cron jobs.
gem 'whenever', require: false

# Search
gem 'mysql2'
gem 'thinking-sphinx'

gem 'gon'

# Amazon S3
gem 'aws-sdk-s3', require: false

# AUTH
gem 'cancancan'
gem 'devise', '~> 4.0'
gem 'omniauth', '~> 1.9.1'
gem 'omniauth-github'
gem 'omniauth-vkontakte'

# UI
gem 'bootstrap', '~> 5.0.1'
gem 'jquery-rails'
gem 'mini_racer', platforms: :ruby

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

gem 'redis'
gem 'redis-rails'

# Server
gem 'unicorn'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Presents a testing environment as an alternative to the standard testing environment
  gem 'rspec-rails', '~> 5.0'
  # To create text data
  gem 'factory_bot_rails'
  # Environment variables
  gem 'dotenv-rails'
  # Preview email in the default browser instead of sending it.
  gem 'letter_opener'

  gem 'rubocop', '~> 1.24', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'listen', '~> 3.3'
  gem 'rack-mini-profiler', '~> 2.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  gem 'capistrano', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-passenger', require: false
  gem 'capistrano-sidekiq', require: false
  gem 'capistrano3-unicorn', require: false
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 3.26'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
  # provides RSpec and Minitest compatible one-liners for testing the general Rails functionality
  gem 'capybara-email'
  gem 'database_cleaner-active_record'
  gem 'rails-controller-testing'
  gem 'shoulda-matchers'
  # auxiliary class for running cross-platform applications
  gem 'launchy'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
