class Provides < MethodDecorator
  def initialize(service_name)
    @service_name = service_name  
  end

  def call(orig, this, *args, &blk)
    orig.call(*args, &blk)
    Services.instance.put(@service_name,this)
    this
  end
end