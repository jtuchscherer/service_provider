require "service_provider/version"

require "singleton"

require "method_decorators"
require "service_provider/method_decorators/requires"
require "service_provider/method_decorators/provides"

require "service_provider/provider/automatic"

module ServiceProvider
  def method_added(method_name)
    super

    decorators = MethodDecorator.current_decorators
    return if decorators.empty?

    provider_decorator = find_and_remove_provider_decorator!(decorators)
    call_original_method_with_other_decorators(method_name, decorators)
    add_provider_service_to_service_provider(provider_decorator.service_name) if provider_decorator
  end

  def self.provider
    ServiceProvider::Provider::Automatic
  end

  private

  def add_provider_service_to_service_provider(requested_service_name)
    ServiceProvider.provider.add_service(requested_service_name, self)
  end

  def call_original_method_with_other_decorators(name, decorators)
    original_method = instance_method(name)

    define_method(name) do |*args, &blk|
      decorated = ServiceProvider.decorate_callable(original_method.bind(self), decorators)
      decorated.call(*args, &blk)
    end
  end

  def find_and_remove_provider_decorator!(decorators)
    provide_decorator_index = decorators.index { |decorator| decorator.is_a? Provides }
    provide_decorator = provide_decorator_index ? decorators.delete_at(provide_decorator_index) : nil
  end

  def self.decorate_callable(orig, decorators)
    decorators.reduce(orig) do |callable, decorator|
      lambda { |*a, &b| decorator.call(callable, orig.receiver, *a, &b) }
    end
  end
end

