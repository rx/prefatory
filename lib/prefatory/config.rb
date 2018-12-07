require 'dry-configurable'

module Prefatory
  extend Dry::Configurable

  setting :logger, Logger.new(STDOUT)
  setting :ttl, 86400 # in seconds - defaults to one day
  setting :storage do
    setting :provider # :memcached or :redis
    setting :options
  end
end
