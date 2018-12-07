
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "prefatory/version"

Gem::Specification.new do |spec|
  spec.name          = "prefatory"
  spec.version       = Prefatory::VERSION
  spec.authors       = ["Russell Edens"]
  spec.email         = ["rx@voomify.com"]

  spec.summary       = %q{Prefatory provides storage of entities (models or values/attributes) in a non-transactional
                          preliminary key value store (redis or memcache).}
  spec.description   = %q{Sometimes you need to collect data before you can write it to the database.
                          That is the impedius for this gem. The collection of data could happen across multiple
                          client interactions spanning pages or even sessions.}
  spec.homepage      = "https://github.com/rx/prefatory"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_dependency "dry-configurable", "~> 0.7.0"

  spec.add_development_dependency "redis"
  spec.add_development_dependency "dalli"
  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
