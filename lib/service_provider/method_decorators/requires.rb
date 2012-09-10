module ServiceProvider
  module MethodDecorators
    class Requires < MethodDecorator
      def initialize(service)
        @service = service
      end

      def call(orig, this, *args, &blk)
        orig.call(*args, &blk)
        this.instance_variable_set("@#{@service.to_sym}", ServiceProvider.provider.get_service(@service.to_sym))
        add_service_setter(this)
        this
      end

      def add_service_setter(this)
        service = @service
        this.class.send(:define_method, "#{service}=") do |value|
          instance_variable_set("@#{service}", value)
        end
      end
    end
  end
end