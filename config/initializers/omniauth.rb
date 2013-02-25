# workaround for omniauth
OmniAuth.config.logger = Logger.new(STDOUT)
OmniAuth.logger.progname = "omniauth"
# workaround for omniauth-saml
module Devise
  module OmniAuth
    class Config
      def autoload_strategy
        name = ::OmniAuth::Utils.camelize(provider.to_s)
        name = "SAML" if name == "Saml"
        if ::OmniAuth::Strategies.const_defined?(name)
          ::OmniAuth::Strategies.const_get(name)
        else
          raise StrategyNotFound, name
        end
      end
    end
  end
end
# suppress warning message of omniauth-openid
OpenID.fetcher.ca_file = '/etc/pki/tls/certs/ca-bundle.crt'
