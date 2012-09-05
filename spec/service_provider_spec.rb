require "spec_helper"
require "service_provider/method_decorators/requires"
require "service_provider/method_decorators/provides"

class SquareService
  extend MethodDecorators

  +Provides.new(:square_service)

  def initialize
  end

  def square(num)
    num * num
  end

  include ServiceProvider
end

class PlusThreeService
  extend MethodDecorators

  +Provides.new(:plus_three_service)

  def initialize
  end

  def plus3(num)
    num + 3
  end

  include ServiceProvider
end

class SuperMathService
  extend MethodDecorators

  +Requires.new(:square_service)
  +Requires.new(:plus_three_service)
  +Provides.new("super_math_service")
  def initialize
  end

  def calculate(num)
    @plus_three_service.plus3 @square_service.square(num)
  end

  include ServiceProvider
end

describe ServiceProvider do
  describe "providing a simple service" do
    it "should work for one client using one service" do
      class SquareSample
        extend MethodDecorators

        +Requires.new(:square_service)

        def initialize
        end

        def do_work(num)
          @square_service.square (num)
        end
      end

      SquareSample.new.do_work(2).should == 4
    end

    it "should work when specifying the service as a string" do
      class SquareSample
        extend MethodDecorators

        +Requires.new("square_service")

        def initialize
        end

        def do_work(num)
          @square_service.square (num)
        end
      end

      SquareSample.new.do_work(2).should == 4
    end

    it "should work for one client using multiple service" do
      class SquareSample
        extend MethodDecorators

        +Requires.new(:square_service)
        +Requires.new(:plus_three_service)
        def initialize
        end

        def do_work(num)
          @plus_three_service.plus3 @square_service.square(num)
        end
      end

      SquareSample.new.do_work(2).should == 7
    end

    it "should work for a client that requires a service which requires a service" do
      class SuperMathSample
        extend MethodDecorators

        +Requires.new(:super_math_service)
        def initialize
        end

        def do_work(num)
          @super_math_service.calculate(num)
        end
      end

      SuperMathSample.new.do_work(19).should == 364
    end
  end
end

