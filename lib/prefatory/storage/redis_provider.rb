require 'redis'

module Prefatory
  module Storage
    class RedisProvider
      KEY_PREFIX = 'prefatory'.freeze


      def initialize(options=nil, ttl=Prefatory.config.ttl,
                     key_generator:  Prefatory.config.keys.generator.new(KEY_PREFIX),
                     marshaler: Prefatory.config.storage.marshaler)
        options = default_settings(options)
        @ttl = ttl
        @key_generator = key_generator
        @marshaler = marshaler
        @client = options ? Redis.new(options) : Redis.current
      end

      def set(key, value, ttl=nil)
        @client.set(prefix(key), @marshaler.dump(value), ex: ttl||@ttl)
      end

      def get(key)
        value = @client.get(prefix(key))
        value ? @marshaler.load(value) : value
      end

      def delete(key)
        @client.del(prefix(key))
      end

      def key?(key)
        @client.exists(prefix(key))
      end

      def next_key(obj=nil)
        @key_generator.key(obj)
      end

      private

      def prefix(key)
        @key_generator.prefix(key)
      end

      def default_settings(options)
        return options if options&.fetch(:url){false} || options&.fetch(:host){false}
        url = ENV['REDIS_PROVIDER'] || ENV['REDIS_URL']
        if (url)
          options ||= {}
          options = options.merge(url: url)
        end
        options
      end
    end
  end
end
