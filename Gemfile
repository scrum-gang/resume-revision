source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.1'

gem 'rails', '~> 5.2.2'
gem 'puma', '~> 3.11'
gem 'pg'
gem 'pry'
gem 'json'
gem 'httparty'
gem 'webmock', '~> 3.0', '>= 3.0.1'
gem "rack-cors", "~> 1.0"

# rails controller testing for integration tests
gem 'rails-controller-testing'

# add azure blob storage
gem "azure-storage"

# Stylesheet gems
gem 'sass-rails', '~> 5.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem "rspec", "~> 3.8"
  gem "rubocop", "~> 0.63.1"
  gem "simplecov", "~> 0.16.1"
  gem "solargraph", "~> 0.31.2"
  gem "travis", "~> 1.8"
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
end
