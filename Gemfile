source 'https://rubygems.org'

# Ruby on Rails is a full-stack web framework optimized for programmer happiness and sustainable productivity. 
# It encourages beautiful code by favoring convention over configuration.
gem 'rails', '3.2.11'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# Pg is the Ruby interface to the PostgreSQL RDBMS.
# It works with PostgreSQL 8.3 and later.
gem 'pg', '0.15.1'

# ActiveRecord extension to get more from PostgreSQL.
gem 'pg_power', '1.6.0'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', '0.11.4', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

# This gem provides jQuery and the jQuery-ujs driver for your Rails 3 application.
gem 'jquery-rails', '3.0.1'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server. LGDSF default Rack HTTP Server.
gem 'unicorn', '4.6.3'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'

# Dalli is a high performance pure Ruby client for accessing memcached servers.
gem 'dalli', '2.6.4'

# jpmobile is Rails plugin for Japanese mobile-phones.
gem 'jpmobile', '4.0.0'

# Devise is Flexible authentication solution for Rails with Warden.
gem 'devise', '2.2.4'

# Devise extension to allow authentication via LDAP.
gem 'devise_ldap_authenticatable', '0.6.1'

# omniauth is external-authorize for Devise.
# A generalized Rack framework for multiple-provider authentication.
gem 'omniauth', '1.1.4'

# OpenID strategy for OmniAuth. Using for Google.
gem 'omniauth-openid', '1.0.1'
gem "ruby-openid", '2.2.3', :git => "git://github.com/kendagriff/ruby-openid.git", :ref => "79beaa419d4754e787757f2545331509419e222e"

# A generic OAuth (1.0/1.0a) strategy for OmniAuth.
gem 'omniauth-oauth', '1.0.1'

# An abstract OAuth2 strategy for OmniAuth. Using for Facebook.
gem 'omniauth-oauth2', '1.1.1'

# A generic SAML strategy for OmniAuth.
gem 'omniauth-saml', '1.0.0', :git => 'https://github.com/ruvr/omniauth-saml.git'

# OmniAuth strategy for Twitter.
gem 'omniauth-twitter', '1.0.0'

# Facebook strategy for OmniAuth.
gem 'omniauth-facebook', '1.4.1'

# LDAP strategy for OmniAuth.
gem 'omniauth-ldap', '1.0.3'

# TabsOnRails is a simple Rails plugin for creating tabs and navigation menus.
gem 'tabs_on_rails', '2.2.0'

group :test do
  # Rspec-2 meta-gem that depends on the other components.
  gem 'rspec', '2.13.0'

  # factory_girl is a fixtures replacement with a straightforward
  # definition syntax, support for multiple build strategies (saved
  # instances, unsaved instances, attribute hashes, and stubbed objects),
  # and support for multiple factories for the same class (user,
  # admin_user, and so on), including factory inheritance.
  gem 'factory_girl_rails', '4.2.1'

  # RSpec matcher for Resque.
  gem 'resque_spec', '0.13.0'
end

# A Rails generator plugin & gem that generates Rails I18n locale files
# for almost every known locale.
gem 'i18n_generators', '1.2.1'

# It provides the interface to some LDAP libraries (e.g. OpenLDAP,
# Netscape SDK and Active Directory). The common API for application
# development is described in RFC1823 and is supported by Ruby/LDAP.
gem 'ruby-ldap', '0.9.13'

# Iconv is a wrapper class for the UNIX 95 iconv() function family,
# which translates string between various encoding systems.
platforms :mri_20 do
  gem "iconv", '1.0.2'
end

# A common interface to multiple JSON libraries, 
# including Oj, Yajl, the JSON gem (with C-extensions), the pure-Ruby JSON gem, NSJSONSerialization, gson.rb, JrJackson, and OkJson.
gem 'multi_json','1.7.6'

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
