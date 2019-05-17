# Overloader

Overload for Ruby

# DO NOT USE THIS LIBRARY FOR PRODUCTION

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'overloader'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install overloader

## Usage

```ruby
require 'overloader'

class A
  extend Overloader
  overload do
    def foo() "no args" end
    def foo(x) "one arg" end
    def foo(x, y) "two args" end
  end
end

a = A.new
p a.foo # => "no args"
p a.foo(1) # => "one args"
p a.foo(1, 2) # => "two args"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pocke/overloader.
