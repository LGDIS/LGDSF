source 'http://rubygems.org'

gem 'rails', '3.2.8'
gem "jquery-rails", "~> 2.0.2"
gem "i18n", "~> 0.6.0"
gem "coderay", "~> 1.0.6"
gem "fastercsv", "~> 1.5.0", :platforms => [:mri_18, :mingw_18, :jruby]
gem "builder", "3.0.0"

# Optional gem for LDAP authentication
group :ldap do
  gem "net-ldap", "~> 0.3.1"
end

# Optional gem for OpenID authentication
group :openid do
  gem "ruby-openid", "~> 2.1.4", :require => "openid"
  gem "rack-openid"
end

# Optional gem for exporting the gantt to a PNG file, not supported with jruby
platforms :mri, :mingw do
  group :rmagick do
    # RMagick 2 supports ruby 1.9
    # RMagick 1 would be fine for ruby 1.8 but Bundler does not support
    # different requirements for the same gem on different platforms
    gem "rmagick", ">= 2.0.0"
  end
end

# Database gems
platforms :mri, :mingw do
  group :postgresql do
    gem "pg", ">= 0.11.0"
  end

  group :sqlite do
    gem "sqlite3"
  end
end

=begin
platforms :mri_18, :mingw_18 do
  group :mysql do
    gem "mysql"
  end
end

platforms :mri_19, :mingw_19 do
  group :mysql do
    gem "mysql2", "~> 0.3.11"
  end
end
=end

platforms :jruby do
  gem "jruby-openssl"

  group :mysql do
    gem "activerecord-jdbcmysql-adapter"
  end

  group :postgresql do
    gem "activerecord-jdbcpostgresql-adapter"
  end

  group :sqlite do
    gem "activerecord-jdbcsqlite3-adapter"
  end
end

group :development do
  gem "rdoc", ">= 2.4.2"
  gem "yard"
end

gem "jpmobile", "3.0.6"
gem 'therubyracer', :platforms => :ruby
gem 'devise'
gem 'execjs'
gem 'uglifier'
