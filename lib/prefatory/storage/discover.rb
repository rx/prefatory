module Prefatory
  module Storage
    class Discover
      def initialize(config, ttl, key_prefix)
        @config = config
        @ttl = ttl
        @key_prefix = key_prefix
        @provider = find_provider(config.provider)
      end

      def instance
        require_relative "#{@provider}_provider"
        Object.const_get("Prefatory::Storage::#{@provider.to_s.capitalize}Provider").new(@config.options, @ttl, @key_prefix)
      end
      private
      def find_provider(provider)
        return provider if provider
        return :redis if defined?(Redis)
        return :memcached if defined?(Dalli)
        raise Errors::Configuration, 'Unable to discover a default storage provider! '\
                                          'You must either have the redis or dalli gem installed.'
      end
    end
  end
end
