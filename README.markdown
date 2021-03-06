# OK Computer

Inspired by the ease of installing and setting up [fitter-happier] as a Rails
application's health check, but frustrated by its lack of flexibility, OK
Computer was born. It provides a robust endpoint to perform server health
checks with a set of built-in plugins, as well as a simple interface to add
your own custom checks.

## Installation

Add this line to your application's Gemfile:

    gem 'okcomputer'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install okcomputer

## Usage

To perform the default checks (application running and ActiveRecord database
connection), do nothing other than adding to your application's Gemfile.

### If Not Using ActiveRecord

We also include a MongoidCheck, but do not register it. If you use Mongoid,
replace the default ActiveRecord check like so:

```ruby
OKComputer::Registry.register "database", OKComputer::MongoidCheck.new
```

If you use another database adapter, see Registering Custom Checks below to
build your own database check and register it with the name "database" to
replace the built-in check, or use `OKComputer::Registry.deregister "database"`
to stop checking your database altogether.

### Registering Additional Checks

Register additional checks in an initializer, like do:

```ruby
# config/initializers/okcomputer.rb
OKComputer::Registry.register "resque_down", OKComputer::ResqueDownCheck.new("critical", 100)
OKComputer::Registry.register "resque_backed_up", OKComputer::ResqueBackedUpCheck.new
```

### Registering Custom Checks

The simplest way to register a check unique to your application is to subclass
OKComputer::Check and implement your own `#call` method, which returns the
output string, and calls `mark_failure` if anything is wrong.

```ruby
# config/initializers/okcomputer.rb
class MyCustomCheck < OKComputer::Check
  def call
    if rand(10).even?
      "Even is great!"
    else
      mark_failure
      "We don't like odd numbers"
    end
  end
end

OKComputer::Registry.register "check_for_odds", MyCustomCheck.new
```

## Performing Checks

* Perform a simple up check: http://example.com/okcomputer
* Perform all installed checks: http://example.com/okcomputer/all
* Perform a specific installed check: http://example.com/okcomputer/database

Checks are available as plain text (by default) or JSON by appending .json, e.g.:
* http://example.com/okcomputer.json
* http://example.com/okcomputer/all.json

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

[fitter-happier]:https://rubygems.org/gems/fitter-happier
