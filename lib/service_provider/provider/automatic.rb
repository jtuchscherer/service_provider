module ServiceProvider
  module Provider
    class Automatic
      def self.add_service(requested_service_name, service_class)
        service_name = requested_service_name ? requested_service_name.to_sym : underscore_string(service_class.name).to_sym
        Services.instance.put service_name, service_class
      end

      def self.get_service(service_name)
        Services.instance.get service_name
      end

      private
      def self.underscore_string(class_name)
        word = class_name.dup
        word.gsub!(/::/, '/')
        word.gsub!(/([A-Z\d]+)([A-Z][a-z])/, '\1_\2')
        word.gsub!(/([a-z\d])([A-Z])/, '\1_\2')
        word.tr!("-", "_")
        word.downcase!
        word
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
    end
  end
end