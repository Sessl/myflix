source 'https://rubygems.org'
ruby '2.2.3'

gem 'bootstrap-sass'
gem 'coffee-rails'
gem 'rails'
gem 'haml-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'bcrypt-ruby'
gem 'bootstrap_form'
gem 'figaro'
gem 'sidekiq'
gem 'unicorn'
gem 'rack-timeout'
gem 'sentry-raven'
gem 'eventmachine', '~>1.0.4'
gem 'carrierwave'
gem 'mini_magick'
gem 'carrierwave-aws'
gem 'stripe'
gem 'stripe_event'
gem 'draper'

group :development do
  gem 'sqlite3'
  gem 'pry'
  gem 'pry-nav'
  gem 'thin'
  gem "better_errors"
  gem "binding_of_caller"
  gem "letter_opener"
end

group :test, :development do
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'fabrication'
  gem 'faker'
end

group :test do
  gem 'capybara'
  gem 'capybara-email'
  gem 'vcr'
  gem 'webmock'
  gem 'selenium-webdriver'
  gem 'database_cleaner'
end

group :production, :staging do
  gem 'pg'
  gem 'rails_12factor'
end

