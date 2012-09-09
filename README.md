# ServiceProvider

Simple attempt to inject dependencies through method decorators (https://github.com/michaelfairley/method_decorators)

## Installation

Add this line to your application's Gemfile:

    gem 'service_provider'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install service_provider

## Usage

The class that provides a dependency has to extend the ServiceProvider module and to decorate its initialize method with the Provides decorator:

```ruby
class SquareService
  extend ServiceProvider

  +Provides
  def initialize
  end
end  
```

The class that requires a service has to extend the MethodDecorators and to decorate its initialize method with the Requires decorator. The argument passed into the Requires decorator will be the name of the instance variable that holds that service.

```ruby
class SquareSample
  extend MethodDecorators

  +Requires.new(:square_service)
  def initialize
  end

  def do_work(num)
    @square_service.square(num)
  end
end
``` 

After a service has been required it can be manually set on the object, through a setter for the instance variable, i.e. `square_service=`.

Known limitatations and uglinesses
- Each class has to have an empty constructor to put the MethodDecorators before it.
- Provider has to extend the ServiceProvider, Requirer has to extend MethodDecorators 

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

== License

Copyright (c) Johannes Tuchscherer

Released under the MIT license. See LICENSE file for details.