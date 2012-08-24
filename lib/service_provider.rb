require "service_provider/version"
require "singleton"

module ServiceProvider
  def self.included(klass)
    objekt = klass.new()
  end

end

class Services
  include Singleton

  def initialize
    @services = {}
  end

  def put(service_name, service)
    @services[service_name] = service
  end

  def get(service_name)
    @services[service_name]
  end
end