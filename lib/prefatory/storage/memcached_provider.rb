require 'dalli'

module Prefatory
  module Storage
    class MemcachedProvider
      DEFAULT_SERVER = '127.0.0.1:11211'.freeze
      DEFAULT_OPTIONS = {namespace: Prefatory.config.keys.prefix, compress: true, cache_nils: true}

      def initialize(options = nil, ttl = nil,
                     key_generator: Prefatory.config.keys.generator.new,
                     marshaler: Prefatory.config.storage.marshaler)
        @ttl = ttl
        @key_generator = key_generator
        @marshaler = marshaler
        @client = Dalli::Client.new(default_servers(options), default_options(options))
      end

      def set(key, value, ttl = nil)
        @client.set(prefix(key), @marshaler.dump(value), ttl || @ttl)
      end

      def get(key)
        value = @client.get(prefix(key))
        value ? @marshaler.load(value) : value
      end

      def delete(key)
        @client.delete(prefix(key))
      end

      def key?(key)
        v = @client.fetch(prefix(key)) {:does_not_exists}
        v != :does_not_exists
      end

      def next_key(obj = nil)
        @key_generator.key(obj)
      end

      private

      def prefix(key)
        @key_generator.prefix(key)
      end


      def default_servers(options)
        return options[:servers] if options&.fetch(:servers) {false}
        DEFAULT_SERVER
      end

      def default_options(options)
        return options.select {|key| key != :servers} if options
        DEFAULT_OPTIONS
      end
    end
  end
end
