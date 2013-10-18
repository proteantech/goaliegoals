source 'https://rubygems.org'
gem 'rails', '3.2.13'
ruby '2.0.0'

#gem 'sqlite3', group => [:development, :test]
#gem 'pg', group => :production
gem 'pg' #
gem 'unicorn'

gem 'rails_12factor', group: :production # used by heroku

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem "haml-rails", ">= 0.4"
gem "html2haml", ">= 1.0.1", :group => :development
gem "bootstrap-sass", ">= 2.3.0.0"
gem "devise", ">= 2.2.3"
gem "figaro", ">= 0.6.3"
gem "better_errors", ">= 0.7.2", :group => :development
gem "binding_of_caller", ">= 0.7.1", :group => :development, :platforms => [:mri_19, :rbx]
gem "hub", ">= 1.10.2", :require => nil, :group => [:development]

group :test do
  gem "mocha", :require => false
  gem 'capybara'
  gem "selenium-webdriver"
  gem 'minitest-reporters'
end

