require 'prefatory/config'
require 'prefatory/errors'

module Prefatory
  module Storage
    class Discover
      def initialize(config, ttl = Prefatory.config.ttl, key_prefix: Prefatory.config.keys.prefix)
        @config = config
        @ttl = ttl
        @key_prefix = key_prefix
        @provider = find_provider(config.provider)
      end

      def instance
        require_relative "#{@provider}_provider"

        class_name = "Prefatory::Storage::#{@provider.to_s.capitalize}Provider"
        storage_class = Object.const_get(class_name)
        storage_class.new(
            @config.options,
            @ttl,
            marshaler: marshaler,
            key_generator: key_generator
        )
      end

      private

      def marshaler
        @config.respond_to?(:marshaler) ? @config.marshaler : Marshal
      end

      def key_generator
        Prefatory.config.keys.generator.new(@key_prefix)
      end

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