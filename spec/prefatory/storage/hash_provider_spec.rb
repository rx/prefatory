require 'prefatory/storage/hash_provider'
require_relative '../prefatory_shared'

RSpec.describe Prefatory::Storage::HashProvider do

  let(:storage) {Prefatory::Storage::HashProvider.new}
  let(:repo) {Prefatory::Repository.new(storage: storage)}
  include_examples 'prefatory_repository'
end
