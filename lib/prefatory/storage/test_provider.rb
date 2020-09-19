module Prefatory
  module Storage
    # Used by Specs. This is not safe for production (in any way!) You have been warned.
    class TestProvider

      def initialize(
          options = nil,
          ttl = Prefatory.config.ttl,
          key_generator: Prefatory.config.keys.generator.new,
          marshaler: Prefatory.config.storage.marshaler
      )
        @hash = {}
        @key_generator = key_generator
        @marshaler = marshaler
      end

      def set(key, value, _ttl=nil)
        @hash.store(key, @marshaler.dump(value))
      end

      def get(key)
        value = @hash.fetch(key){nil}
        value ? @marshaler.load(value) : value
      end

      def key?(key)
        @hash.key?(key)
      end

      def delete(key)
        @hash.delete(key)
      end

      def next_key(obj = nil)
        @key_generator.key(obj)
      end
    end
  end
end