module ServiceProvider
  module MethodDecorators
    class Requires < MethodDecorator
      def initialize(service_name)
        @service_name = service_name
      end

      def call(orig, this, *args, &blk)
        orig.call(*args, &blk)
        this.instance_variable_set("@#{@service_name.to_sym}", ServiceProvider.provider.get_service(@service_name.to_sym))
        add_service_setter(this)
        add_service_getter(this)
        this
      end

      def add_service_setter(this)
        service_name = @service_name
        this.class.send(:define_method, "#{service_name}=") do |value|
          instance_variable_set("@#{service_name}", value)
        end
      end
      
      def add_service_getter(this)
        service_name = @service_name
        this.class.send(:define_method, "#{service_name}") do 
          service = instance_variable_get("@#{service_name.to_sym}")
          unless service
            service = ServiceProvider.provider.get_service(service_name.to_sym)
            instance_variable_set("@#{service_name.to_sym}", service)
          end  
          service
        end
      end
    end
  end
end