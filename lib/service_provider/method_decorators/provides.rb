class Provides < MethodDecorator
  attr_reader :service_name
  
  def initialize(service_name = nil)
    @service_name = service_name  
  end
end