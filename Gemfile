source 'https://rubygems.org'

# ruby '2.6.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.4', '>= 5.2.4.5'

# Use SCSS for stylesheets
# gem 'sass'
# gem 'sass-rails', '~> 5.0'
gem 'sassc', '>= 2.0.0'
gem 'sassc-rails', '~> 2.1', '>= 2.1.2'
gem 'bootstrap-sass', '~> 3.4.1'
gem "json", ">= 2.3.0"

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '~> 4.2'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 5.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'jquery-turbolinks'
gem 'i18n-js'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks', '~>5'

# gem 'less-rails'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', '~> 2.0.4', group: :doc, require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# for Heroku deployment - as described in Ap. A of ELLS book
group :development, :test do
  gem 'database_cleaner'
  gem 'capybara'
  gem 'simplecov'
  gem 'launchy'
end

group :test do
  gem 'cucumber-rails', :require => false
  gem 'cucumber-rails-training-wheels'
  gem 'factory_girl'
  gem 'factory_girl_rails', :require => false
  gem 'rspec'
  gem 'rspec-rails', '~> 3.4', '>= 3.4.2'
  gem 'rspec-activemodel-mocks', '~> 1.0', '>= 1.0.3'
  gem 'sqlite3'
end

group :development, :production do
  gem 'mysql2', '~> 0.3.20'
end

group :development do
  gem 'puma', '>= 3.12.4'
  gem 'rails-erd', '~> 1.5', '>= 1.5.2'
end

# For Heroku deployment
group :production do
  gem 'rails_12factor'
end

gem 'dynamic_form'
gem 'pdf-reader'
gem 'docsplit'

gem 'unf'
