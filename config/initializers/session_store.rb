# Be sure to restart your server when you modify this file.
require 'action_dispatch/middleware/session/dalli_store'
Lgdsf::Application.config.session_store :cookie_store, key: '_LGDSF_session'

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# Lgdsf::Application.config.session_store :active_record_store

# To use Dalli memcached client library for Rails Session Storage.
# Lgdsf::Application.config.session_store ActionDispatch::Session::CacheStore, :expire_after => 20.minutes
