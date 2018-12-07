require 'prefatory/storage/memcached_provider'
require_relative '../prefatory_shared'

RSpec.describe Prefatory::Storage::MemcachedProvider do

  let(:storage) {Prefatory::Storage::MemcachedProvider.new}
  let(:repo) {Prefatory::Repository.new(storage: storage)}
  include_examples 'prefatory_repository'
end

