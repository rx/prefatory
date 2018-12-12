module Prefatory
  module Storage
    # Used by Specs. This is not safe for production (in any way!) You have been warned.
    class TestProvider
      include Prefatory::Keys

      def initialize(ttl = nil, key_prefix = nil)
        @ttl = ttl
        @key_prefix = key_prefix
        @hash = {}
        @next_key = 0
      end

      def set(key, value, ttl=nil)
        @hash.store(key, value)
      end

      def get(key)
        @hash.fetch(key){nil}
      end

      def key?(key)
        @hash.key?(key)
      end

      def delete(key)
        @hash.delete(key)
      end

      def next_key(obj = nil)
        build_key(obj, @next_key += 1, @key_prefix)
      end
    end
  end
end
