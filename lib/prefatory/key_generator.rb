require 'securerandom'

module Prefatory
  class KeyGenerator
    def initialize(prefix = nil)
      @prefix = prefix
    end

    def prefix(key)
      [@prefix, key].compact.join(':')
    end

    def key(obj)
      next_key = obj.send(Prefatory.config.keys.primary_uuid) if obj.respond_to?(Prefatory.config.keys.primary_uuid)
      next_key = SecureRandom.hex(16) unless next_key
      next_key
    end
  end
end
