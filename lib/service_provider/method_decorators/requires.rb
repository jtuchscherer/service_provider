class Requires < MethodDecorator
  def initialize(service)
    @service = service  
  end

  def call(orig, this, *args, &blk)
    orig.call(*args, &blk)
    this.instance_variable_set("@#{@service.to_sym}", Services.instance.get(@service.to_sym))
    this
  end
end