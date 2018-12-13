# Prefatory

Prefatory provides an ultra-lightweight storage of entities (models or values/attributes) in a non-transactional 
preliminary key value store (redis or memcache).
                          
Sometimes you need to collect data before you can write it to the database.
That is the impetus for this gem. The collection of data could happen across multiple client interactions spanning 
pages or even sessions.

You can store anything that can be serialized using Ruby's Mashal class.
                          
## Installation

Add this line to your application's Gemfile:

    gem 'prefatory'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install prefatory

## Usage

To store and retrieve an entity/model/value/hash/array:

    foo_key = Prefatory.save(foo)      
    foo = Prefatory.find(foo_key)
  
Save returns nil if the save was unable to save the entity/model/value/hash/array. Find returns nil of the key could not be found.
   
Save also takes a ttl as an optional parameter. See configuration for setting the ttl default.

You can also use the bang methods. The find! method raises Prefatory::NotFound if the object could not be found.
The save! method raises Prefatory::NotSaved if the object could not be saved.

You can also store and retrieve ruby built in types including arrays and hashes.

## Configuration

Optional.

The gem will automatically look for Redis as the key value store. 
If it doesn't find it it will look for Memcache.

Redis:

# default configuration:
    Prefatory.configure do |config|
      config.storage.provider = :redis
      # accepts any additional options redis-rb gem accepts          
      config.storage.options = {url: ENV['REDIS_URL']||Redis.current||'redis://127.0.0.1:0'}
      config.ttl =  
    end

Memcache:

# default configuration
    Prefatory.configure do |config|
      config.storage.engine = :memcache
      # accepts any additional options dalli gem accepts 
      config.storage.options = {servers: [ENV['MEMCACHE_URL']]}       
    end

Logger:

    Prefatory.configure do |config|
      setting :logger, Logger.new(STDOUT)
    end

TTL:

    Prefatory.configure do |config|
      setting :ttl, 86400 # in seconds - defaults to one day
    end

You can set this to nil, but it is **NOT** recommended as you may fill up your prefatory storage.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rx/prefatory. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Prefatory project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/rx/prefatory/blob/master/CODE_OF_CONDUCT.md).
