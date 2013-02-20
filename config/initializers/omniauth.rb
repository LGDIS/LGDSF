# workaround for omniauth
OmniAuth.config.logger = Logger.new(STDOUT)
OmniAuth.logger.progname = "omniauth"
# suppress warning message of omniauth-openid
OpenID.fetcher.ca_file = '/etc/pki/tls/certs/ca-bundle.crt'
