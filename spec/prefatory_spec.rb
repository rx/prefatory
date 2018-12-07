require 'prefatory/storage/test_provider'
require_relative 'prefatory/prefatory_shared'

RSpec.describe Prefatory do
  include_examples 'prefatory_repository'

  let(:storage) {Prefatory::Storage::TestProvider.new}
  let(:repo) {Prefatory::Repository.new(storage: storage)}

  it "has a version number" do
    expect(Prefatory::VERSION).not_to be nil
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

