require "service_provider/version"
require "singleton"

module ServiceProvider
  def method_added(name)
    super
    orig_method = instance_method(name)
    provide_decorator = nil

    decorators = MethodDecorator.current_decorators
    return  if decorators.empty?
    
    provide_decorator_index = decorators.index do |decorator| 
      decorator.is_a? Provides
    end
    
    if provide_decorator_index
      provide_decorator =  decorators[provide_decorator_index]
      decorators.delete(provide_decorator)
    end  
    
    define_method(name) do |*args, &blk|
      decorated = ServiceProvider.decorate_callable(orig_method.bind(self), decorators)
      decorated.call(*args, &blk)
    end
    
    if provide_decorator
      Services.instance.put(provide_decorator.service_name.to_sym,self)
    end
  end

  def self.decorate_callable(orig, decorators)
    decorators.reduce(orig) do |callable, decorator|
      lambda{ |*a, &b| decorator.call(callable, orig.receiver, *a, &b) }
    end
  end
end


class Services
  include Singleton

  def initialize
    @services = {}
    @service_constructors = {}
  end

  def put(service_name, service_class)
    @service_constructors[service_name] = service_class
  end

  def get(service_name)
    @services[service_name] ||= @service_constructors[service_name].new
  end
end