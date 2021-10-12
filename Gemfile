source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.5'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.4.2'
# Use mysql as the database for Active Record
gem 'mysql2', '>= 0.4.4', '< 0.6.0'
# Use Puma as the app server
gem 'puma', '~> 5.5'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false


######################################
# by Dongseop
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'toastr-rails'
gem 'nokogiri'
gem 'kaminari'
gem 'browser'
gem 'simple_bioc', '~> 0.0.24'
gem 'semantic-ui-sass'
gem 'mailgun_rails'
gem 'tsv'
gem 'rubyzip'
gem 'httparty'
gem 'devise', github: 'heartcombo/devise', branch: 'ca-omniauth-2'
gem "recaptcha"
gem "docsplit"
gem "font-awesome-rails"
gem "sitemap_generator"

gem 'capistrano', '~> 3.11'
gem 'capistrano-rails', '~> 1.4'
gem 'capistrano3-puma' , group: :development
gem 'capistrano-rbenv', '~> 2.1', '>= 2.1.4'

gem "sentry-raven"

# https://medium.com/@_benrudolph/end-to-end-devise-omniauth-google-api-rails-7f432b38ed75
gem 'omniauth-google-oauth2'
gem "bower-rails", "~> 0.11.0"
# gem 'lightbox2-rails'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end


# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
