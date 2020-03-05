module Prefatory
  module Storage
    # a simple store, for when prefatory is injected into your interface but
    # only ephemeral storage is required
    class HashProvider
      def initialize(
        options = nil,
        ttl = Prefatory.config.ttl,
        key_generator: Prefatory.config.keys.generator.new,
        marshaler: Prefatory.config.storage.marshaler
      )
        @hash = {}
        @key_generator = key_generator
      end

      def set(key, value, ttl=nil)
        @hash.store(key, value)
      end

      def get(key)
        value = @hash.fetch(key){nil}
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
