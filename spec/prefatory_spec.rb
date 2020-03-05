require 'prefatory/storage/test_provider'
require_relative 'prefatory/prefatory_shared'

RSpec.describe Prefatory do
  include_examples 'prefatory_repository'

  let(:storage) {Prefatory::Storage::TestProvider.new}
  let(:repo) {Prefatory::Repository.new(storage: storage)}

  it "has a version number" do
    expect(Prefatory::VERSION).not_to be nil
  end

  context 'with a key_prefix' do
    it 'does not mutate the global config key_prefix' do
      initial_key_prefix = Prefatory.config.keys.prefix

      Prefatory::Repository.new(storage: storage, key_prefix: 'foo')
      expect(Prefatory.config.keys.prefix).to eq(initial_key_prefix)
    end
  end

  describe :save! do
    let(:storage) do
      s = Prefatory::Storage::TestProvider.new

      def s.set(key, value)
        raise StandardError
      end

      s
    end

    it :raises do
      expect {repo.save!('should raise')}.to raise_error(Prefatory::Errors::NotSaved)
    end
  end
end

