source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

gem 'rails', '~> 5.2.2'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.11'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'slim-rails'
gem 'devise'
gem 'bootstrap'
gem 'jquery-rails'
gem 'devise-bootstrap-views', '~> 1.0'
gem 'mini_racer'
gem 'twitter-bootstrap-rails'
gem 'bootstrap-generators'
gem 'aws-sdk-s3'
gem 'cocoon'
gem 'gist-embed-rails'
gem 'gon'
gem 'skim'
gem 'omniauth'
gem 'omniauth-github'
gem 'omniauth-twitter'
gem 'cancancan'
gem 'pundit'
gem 'doorkeeper'
gem 'active_model_serializers', '~> 0.10'
gem 'oj'
gem 'sidekiq'
gem 'sinatra', require: false
gem 'whenever', require: false
gem 'mysql2'
gem 'thinking-sphinx'
gem 'mini_racer'
gem 'capistrano-sidekiq', require: false
gem 'unicorn'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '~> 3.8'
  gem 'factory_bot_rails'
  gem 'pry'
  gem 'capybara-email'
  gem 'capistrano', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-passenger', require: false
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'letter_opener'
  gem 'capistrano3-unicorn'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  gem 'chromedriver-helper'
  gem 'shoulda-matchers', '4.0.0.rc1'
  gem 'rails-controller-testing' # If you are using Rails 5.x
  gem 'launchy'
  gem 'database_cleaner'
  gem 'json_spec'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
