source 'http://ruby.taobao.org'

gem 'rails', '3.2.8'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'


gem 'jquery-rails'
gem 'slim', '1.3.0'
# 这个需要测试, 如果在 application.rb 替换了默认模板,删除这个 gem 无效的话则重新添加回来
gem 'slim-rails'
gem 'twitter-bootstrap-rails', '2.1.3'

# 分页
gem 'kaminari'
gem 'kaminari-bootstrap'


group :production do
  gem 'mysql2'
  gem 'unicorn', '4.3.1'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  #gem 'sass-rails', '~> 3.2.3'
  gem 'less-rails', '~> 2.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby
  gem 'uglifier', '>= 1.0.3'
end

group :development do
  gem 'thin', '1.4.1'
  #gem 'unicorn', '4.3.1'
  gem 'mysql2'
  gem 'annotate', '2.5.0'
  gem 'RedCloth'
  gem 'faker', '1.0.1'
  gem 'hirb'
end

group :test do
  gem 'sqlite3', '1.3.6'
  gem 'rspec-rails', '2.11.0'
  gem 'capybara', '1.1.2'
  gem 'spork-rails', '3.2.0'
  gem 'factory_girl_rails', '4.0.0'
end

# To use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
