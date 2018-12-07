require 'dalli'

module Prefatory
  module Storage
    class MemcachedProvider
      include Prefatory::Keys
      DEFAULT_SERVER = '127.0.0.1:11211'.freeze
      DEFAULT_OPTIONS = {namespace: 'prefatory', compress: true}

      def initialize(options, ttl=nil, key_prefix=nil)
        @ttl = ttl
        @key_prefix = key_prefix
        @client = Dalli::Client.new(default_servers(options), default_options(options))
      end

      def set(key, value, ttl=nil)
        @client.set(key, value, ttl||@ttl)
      end

      def get(key)
        @client.get(key)
      end

      def delete(key)
        @client.delete(key)
      end

      def next_key(obj=nil)
        build_key(obj, @client.incr(build_key(obj, nil, @key_prefix), 1, nil, 0), @key_prefix)
      end

      private

      def default_servers(options)
        return options[:servers] if options&.fetch(:servers) {false}
        DEFAULT_SERVER
      end

      def default_options(options)
        return options.except(:servers) if options
        DEFAULT_OPTIONS
      end
    end
  end
end
