require 'redis'

module Prefatory
  module Storage
    class RedisProvider
      include Prefatory::Keys

      def initialize(options, ttl, key_prefix=nil)
        options = default_settings(options)
        @ttl = ttl
        @key_prefix = key_prefix
        @client = options ? Redis.new(options) : Redis.current
      end

      def set(key, value, ttl=nil)
        @client.set(key, value, ex: ttl||@ttl)
      end

      def get(key)
        @client.get(key)
      end

      def delete(key)
        @client.del(key)
      end

      def next_key(obj=nil)
        build_key(obj, @client.incr(build_key(obj, nil, @key_prefix)), @key_prefix)
      end

      private

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
