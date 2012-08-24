class Requires < MethodDecorator
  def initialize(service)
    @service = service  
  end

  def call(orig, this, *args, &blk)
    orig.call(*args, &blk)
    this.instance_variable_set("@#{@service.to_s}", Services.instance.get(:square_service))
    this
  end
end