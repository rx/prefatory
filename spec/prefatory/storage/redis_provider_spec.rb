require 'prefatory/storage/redis_provider'
require_relative '../prefatory_shared'

RSpec.describe Prefatory::Storage::RedisProvider do

  let(:storage) {Prefatory::Storage::RedisProvider.new}
  let(:repo) {Prefatory::Repository.new(storage: storage)}
  include_examples 'prefatory_repository'
end

