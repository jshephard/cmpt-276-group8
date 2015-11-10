source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.4'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
gem 'coffee-script-source', '1.8.0', platforms: [:mswin]
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: [:ruby]
gem 'therubyrhino', platforms: [:jruby]
gem 'underscore-rails'
gem 'gmaps4rails'
gem "geocoder"
gem 'tzinfo-data', platforms: [:mingw, :mswin, :jruby]

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Used for pagination of various models
gem 'kaminari'
gem 'bootstrap-sass', '3.3.5.0'
# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'puma'

group :development, :test do
	gem 'activerecord-jdbcsqlite3-adapter', platforms: [:jruby]
	gem 'sqlite3', platforms: [:ruby]
	gem 'byebug', platforms: [:ruby]
	gem 'web-console', '~> 2.0', platforms: [:ruby]
	gem 'spring'
end

group :production do
  gem 'pg',             '0.17.1', platforms: [:ruby]
  gem 'activerecord-jdbcpostgresql-adapter', platforms: [:jruby]
  gem 'rails_12factor', '0.0.2'
end
