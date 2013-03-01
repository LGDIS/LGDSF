source 'https://rubygems.org'

gem 'rails', '3.2.11'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# Pg is the Ruby interface to the PostgreSQL RDBMS.
# It works with PostgreSQL 8.3 and later.
gem 'pg'

# ActiveRecord extension to get more from PostgreSQL.
gem 'pg_power'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server. LGDSF default Rack HTTP Server.
gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'

# Dalli is a high performance pure Ruby client for accessing memcached servers.
gem 'dalli'

# jpmobile is Rails plugin for Japanese mobile-phones.
gem 'jpmobile'

# Devise is Flexible authentication solution for Rails with Warden.
gem 'devise'

# Devise extension to allow authentication via LDAP.
gem 'devise_ldap_authenticatable'

# omniauth is external-authorize for Devise.
# A generalized Rack framework for multiple-provider authentication.
gem 'omniauth'

# OpenID strategy for OmniAuth. Using for Google.
gem 'omniauth-openid'

# A generic OAuth (1.0/1.0a) strategy for OmniAuth.
gem 'omniauth-oauth'

# An abstract OAuth2 strategy for OmniAuth. Using for Facebook.
gem 'omniauth-oauth2'

# A generic SAML strategy for OmniAuth.
gem 'omniauth-saml', '1.0.0', :git => 'git://github.com/ruvr/omniauth-saml.git'

# OmniAuth strategy for Twitter.
gem 'omniauth-twitter'

# Facebook strategy for OmniAuth.
gem 'omniauth-facebook'

group :test do
  # Rspec-2 meta-gem that depends on the other components.
  gem 'rspec'

  # factory_girl is a fixtures replacement with a straightforward
  # definition syntax, support for multiple build strategies (saved
  # instances, unsaved instances, attribute hashes, and stubbed objects),
  # and support for multiple factories for the same class (user,
  # admin_user, and so on), including factory inheritance.
  gem 'factory_girl_rails'

  # RSpec matcher for Resque.
  gem 'resque_spec'
end

# A Rails generator plugin & gem that generates Rails I18n locale files
# for almost every known locale.
gem 'i18n_generators'

# It provides the interface to some LDAP libraries (e.g. OpenLDAP,
# Netscape SDK and Active Directory). The common API for application
# development is described in RFC1823 and is supported by Ruby/LDAP.
gem 'ruby-ldap'

# Iconv is a wrapper class for the UNIX 95 iconv() function family,
# which translates string between various encoding systems.
platforms :mri_20 do
  gem "iconv"
end

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
