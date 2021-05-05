require 'bigdecimal'

RSpec.shared_examples 'prefatory_repository' do
  MAX_INT ||= (2 ** (0.size * 8 - 2) - 1)
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
                         BigDecimal => BigDecimal(rand(Float::MIN..Float::MAX), 0),
                         Array => Array.new(rand(0...9)) {rand(0...9)},
                         Hash => Array.new(rand(0...9)) {[rand(0...9), rand(0...9)]}.to_h
  }}

  let(:random_data) {built_in_types[built_in_types.keys[rand(1..built_in_types.keys.size - 1)]]}

  describe [:save, :find].join('/') do
    context :built_in_types do
      it :saves do
        # Built in types with some random data
        built_in_types.each do |k, v|
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

  describe :save_with_uuid do
    class A
      include Comparable
      def primary_uuid
        @primary_uuid ||= SecureRandom.hex
      end
      def <=>(other)
        @primary_uuid <=> other.primary_uuid
      end
    end
    it :saves do
      o = A.new
      k = repo.save(o)
      expect(k).to eq(o.primary_uuid)
      expect(repo.find(k)).to eq(o)
      expect(repo.find(o.primary_uuid)).to eq(o)
    end
  end
end