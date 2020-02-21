require_relative "prefatory/version"
require_relative 'prefatory/config'
require_relative 'prefatory/errors'
require_relative 'prefatory/storage/discover'

module Prefatory
  # A repository that temporarily saves ruby objects to a key value store (Redis or Memcached).
  class Repository
    KEY_NOT_FOUND_MSG = "Unable to find the object with key ?"

    def initialize(key_prefix: nil, storage: nil,
                   config: Prefatory.config)
      @config = config
      @config.keys.prefix = key_prefix if key_prefix
      @storage = storage || Storage::Discover.new(@config.storage, @config.ttl).instance
    end

    def find(key)
      return nil unless @storage.key?(key)
      @storage.get(key)
    end

    def find!(key)
      raise Errors::NotFound, KEY_NOT_FOUND_MSG.sub('?',key) unless @storage.key?(key)
      obj = find(key)
      obj
    end

    def save(obj, ttl=nil)
      begin
        key = @storage.next_key(obj)
        @storage.set(key, obj, ttl)
      rescue StandardError => e
        logger.info("An error occurred (#{e.inspect}) storing object: #{obj.inspect}")
        key = nil
      end
      key
    end

    def save!(obj, ttl=nil)
      key = save(obj, ttl)
      raise Errors::NotSaved,
            "Unable to save object! #{obj.inspect}. Check the log for more information." unless @storage.key?(key)
      key
    end

    def update(key, obj, ttl=nil)
      return false unless @storage.key?(key)
      @storage.set(key, obj, ttl)
      true
    end

    def update!(key, obj, ttl=nil)
      raise Errors::NotFound, KEY_NOT_FOUND_MSG.sub('?',key) unless @storage.key?(key)

      update(key, obj, ttl)
    end

    def delete(key)
      return false unless @storage.key?(key)
      @storage.delete(key)
      true
    end

    def delete!(key)
      raise Errors::NotFound, KEY_NOT_FOUND_MSG.sub('?',key) unless @storage.key?(key)
      delete(key)
    end

    private

    def logger
      @config.logger
    end
  end
end
