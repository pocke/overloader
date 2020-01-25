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

## Advanced Usage: types

You can define overload with types. This feature requires Ruby 2.7 or later.

First, add `require 'overloader/type'`.
Then, define the method type with RBS syntax. https://github.com/ruby/ruby-signature


```ruby
require 'overloader'
require 'overloader/type'

class A
  extend Overloader
  overload do
    # (String, Integer) -> untyped
    def foo(x, y) 'str int' end

    # (Integer, String) -> untyped
    def foo(x, y) 'int str' end

    # (Symbol, Symbol) -> untyped
    def foo(x, y) 'sym sym' end
  end
end

a = A.new
p a.foo('bar', 42) # => "str int"
p a.foo(42, 'baz') # => "int str"
p a.foo(:a, :b)    # => "sym sym"
p a.foo(:a, 42)    # => ArgumentError
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pocke/overloader.
