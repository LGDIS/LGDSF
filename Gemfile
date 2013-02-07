source 'http://rubygems.org'

gem 'rails', '3.2.11'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# Pg is the Ruby interface to the PostgreSQL RDBMS.
# It works with PostgreSQL 8.3 and later.
gem 'pg', '0.14.1'

# ActiveRecord extension to get more from PostgreSQL.
gem 'pg_power', '1.3.0'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '3.2.6'
  gem 'coffee-rails', '3.2.2'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', '0.11.3', :platforms => :ruby

  gem 'uglifier', '1.0.3'
end

gem 'jquery-rails', '2.2.0'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server. LGDPF default Rack HTTP Server.
gem 'unicorn', '4.5.0'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'

# Dalli is a high performance pure Ruby client for accessing memcached servers.
gem 'dalli', '2.6.0'

# jpmobile is Rails plugin for Japanese mobile-phones.
gem 'jpmobile', '3.0.7'

# Devise is Flexible authentication solution for Rails with Warden.
gem 'devise', '2.2.2'

# Devise extension to allow authentication via LDAP.
gem 'devise_ldap_authenticatable', '0.6.1'

gem 'ruby-ldap', '0.9.12'

# Load Local Gemfile
local_gemfile = File.join(File.dirname(__FILE__), "Gemfile.local")
if File.exists?(local_gemfile)
  puts "Loading Gemfile.local ..." if $DEBUG # `ruby -d` or `bundle -v`
  instance_eval File.read(local_gemfile)
end

# Load plugins' Gemfiles
Dir.glob File.expand_path("../plugins/*/Gemfile", __FILE__) do |file|
  puts "Loading #{file} ..." if $DEBUG # `ruby -d` or `bundle -v`
  instance_eval File.read(file)
end

group :test do
  gem 'rspec', '2.12.0'
  
  gem 'factory_girl_rails', '4.2.0'
  
  gem 'resque_spec', '0.13.0'
end

gem 'i18n_generators', '1.2.1'
