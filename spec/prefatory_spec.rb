require 'prefatory/storage/test_provider'
require 'bigdecimal'

RSpec.describe Prefatory do
  MAX_INT = (2 ** (0.size * 8 - 2) - 1)

  it "has a version number" do
    expect(Prefatory::VERSION).not_to be nil
  end

  describe Prefatory::Repository do
    let(:storage) {Prefatory::Storage::TestProvider.new}
    let(:repo) {Prefatory::Repository.new(storage: storage)}
    class Foo
      attr_reader :data

      def initialize(data)
        @data = data
      end

      include Comparable

      def <=>(other)
        @data == other.data
      end
    end
    let(:built_in_types) {{NilClass => nil,
                           TrueClass => true,
                           FalseClass => false,
                           String => (0...8).map {(65 + rand(26)).chr}.join,
                           Integer => rand(0..MAX_INT),
                           Float => rand(Float::MIN..Float::MAX),
                           BigDecimal => BigDecimal.new(rand(Float::MIN..Float::MAX), 0),
                           Array => Array.new(rand(0...9)) {rand(0...9)},
                           Hash => Array.new(rand(0...9)) {[rand(0...9), rand(0...9)]}.to_h
    }}

    let(:random_data) {built_in_types[built_in_types.keys[rand(1..built_in_types.keys.size - 1)]]}

    describe [:save, :find].join('/') do
      context :built_in_types do
        it :saves do
          # Built in types with some random data
          built_in_types.each do |k, v|
            puts k
            key = repo.save(v)
            expect(repo.find(key)).to eq(v)
          end
        end
      end

      context :objects do
        it :saves do
          obj = Foo.new(random_data)
          key = repo.save(obj)
          expect(repo.find(key) <=> obj).to eq(true)
        end
      end
    end

    describe :update do
      context :built_in_types do
        it :updates do
          # Built in types with some random data
          built_in_types.each do |k, v|
            puts "#{k}"
            key = repo.save(v)
            v2 = random_data
            repo.update(key, v2)
            expect(repo.find(key)).to eq(v2)
          end
        end
      end
    end

    describe [:save!, :find!].join('/') do
      context :built_in_types do
        it :saves do
          # Built in types with some random data
          built_in_types.each do |k, v|
            puts "#{k}"
            key = repo.save!(v)
            expect(repo.find!(key)).to eq(v)
          end
        end
      end
    end

    describe :delete do
      it :deletes do
        key = repo.save(random_data)
        repo.delete(key)
        expect(repo.find(key)).to eq(nil)
      end
    end

    describe :find! do
      it :raises do
        expect {repo.find!('does not exist')}.to raise_error(Prefatory::Errors::NotFound)
      end
    end

    describe :delete! do
      it :works do
        key = repo.save(random_data)
        expect {repo.delete!(key)}.not_to raise_error
      end

      it :raises do
        expect {repo.delete!('does not exist')}.to raise_error(Prefatory::Errors::NotFound)
      end
    end

    describe :update! do
      it :works do
        key = repo.save(random_data)
        expect {repo.update!(key, random_data)}.not_to raise_error
      end


      it :raises do
        expect {repo.update!('does not exist', 'blah')}.to raise_error(Prefatory::Errors::NotFound)
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
end

