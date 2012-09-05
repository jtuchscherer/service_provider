class Provides < MethodDecorator
  attr_reader :service_name
  
  def initialize(service_name)
    @service_name = service_name  
  end

  def call(orig, this, *args, &blk)
    orig.call(*args, &blk)
    Services.instance.put(@service_name.to_sym,this)
    this
  end
end