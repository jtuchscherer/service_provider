class Requires < MethodDecorator
  def initialize(service)
    @service = service  
  end

  def call(orig, this, *args, &blk)
    orig.call(*args, &blk)
    this.instance_variable_set("@#{@service.to_sym}", ServiceProvider.provider.get_service(@service.to_sym))
    this
  end
end