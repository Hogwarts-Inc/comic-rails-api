# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.0'

gem "aws-sdk-s3"
gem 'aws-eventstream', '1.2.0'
gem 'pg', '~> 1.1'
gem 'pg_search', '~> 2.3', '>= 2.3.2'
gem 'pry'
gem 'puma', '~> 5.0'
gem 'rack-cors'
gem 'rails', '~> 7.0.4', '>= 7.0.4.2'
gem 'rspec-rails'
gem 'rswag'
gem 'rubocop', require: false
gem 'azure-storage-blob'
gem 'activeadmin'
gem 'activeadmin_addons'
gem 'devise'
gem 'sass-rails'
gem 'sprockets', '<4'
gem 'jwt'
gem 'dotenv-rails'
gem 'multi_json'
gem 'sidekiq', '~> 7.1'
gem 'image_processing'
gem 'mini_magick'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem "rack-cors"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri mingw x64_mingw]
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end
