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
Service provider comes with an automatic service provider, which registers every provided service under its name. You can specify your own service provider (see below).

### Providing a service
The class that provides a dependency has to extend the `ServiceProvider` module and to decorate its initialize method with the `Provides` decorator:

```ruby
class SquareService
  extend ServiceProvider

  +Provides
  def initialize
  end
end  
```
The (suggested) name of the service provided defaults to the underscored class name, and can also be given as a parameter: `+Provides.new(:square_service)`. The standard service provider used will use this name as the name of the service. Custom service providers (see below) might not make use of this information.

### Using a service
The class that requires a service has to extend the `MethodDecorators` module and to decorate its initialize method with the `Requires` decorator. The argument passed into the `Requires` decorator will be the name of the instance variable that holds that service.

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

### Using a custom service provider
You might want to specify how services are provided when you have multiple classes that implement the same service or when you want to change the implementations completely, i.e. for tests. To do so, provide your own service provider and register it with `ServiceProvider`:

```ruby
class CustomServiceProvider
  def provide(service_class, service_class_provided_service_name)
    #how to store services
  end

  def get_service(service_name)
    #how to retrieve services by name
  end
end

ServiceProvider.provider_implementation = CustomServiceProvider.new
```

### Known limitatations and uglinesses
- Each class has to have an empty constructor to put the MethodDecorators before it.
- Provider has to extend the ServiceProvider, Requirer has to extend MethodDecorators

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

Copyright (c) Johannes Tuchscherer

Released under the MIT license. See LICENSE file for details.