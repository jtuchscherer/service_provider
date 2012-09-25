require "spec_helper"

class SquareService
  extend ServiceProvider

  +Provides.new(:square_service)
  def initialize
  end

  def square(num)
    num * num
  end
end

class PlusThreeService
  extend ServiceProvider

  +Provides.new(:plus_three_service)
  def initialize
  end

  def plus3(num)
    num + 3
  end
end

class MinusTwoService
  extend ServiceProvider

  +Provides
  def initialize
  end

  def minus2(num)
    num - 2
  end
end

class SuperMathService
  extend ServiceProvider

  +Requires.new(:square_service)
  +Requires.new(:plus_three_service)
  +Provides.new("super_math_service")
  def initialize
  end

  def calculate(num)
    @plus_three_service.plus3 @square_service.square(num)
  end
end

describe ServiceProvider do

  it "should be possible to override the service provider used" do
    class SquareSample
      extend MethodDecorators

      +Requires.new(:square_service)
      def initialize
      end

      def do_work(num)
        square_service.square (num)
      end
    end

    square_service_mock = mock('SquareService', square: Math::PI)

    service_provider_mock = mock('ServiceProvider')
    service_provider_mock.stub(:add_service)
    service_provider_mock.stub(:get_service).with(:square_service).and_return(square_service_mock)

    ServiceProvider.provider = service_provider_mock

    SquareSample.new.do_work(999).should == Math::PI

    #cleanup
    ServiceProvider.provider = nil
  end


  context "constructor based injection" do
    describe "providing a simple service" do
      it "should work for one client using one service" do
        class SquareSample
          extend MethodDecorators

          +Requires.new(:square_service)
          def initialize
          end

          def do_work(num)
            square_service.square (num)
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
            square_service.square (num)
          end
        end

        SquareSample.new.do_work(2).should == 4
      end

      it "should work when not specifying the service name" do
        class SquareSample
          extend MethodDecorators

          +Requires.new("minus_two_service")
          def initialize
          end

          def do_work(num)
            minus_two_service.minus2 (num)
          end
        end

        SquareSample.new.do_work(4).should == 2
      end

      it "should work for one client using multiple service" do
        class SquareSample
          extend MethodDecorators

          +Requires.new(:square_service)
          +Requires.new(:plus_three_service)
          def initialize
          end

          def do_work(num)
            plus_three_service.plus3 square_service.square(num)
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
            super_math_service.calculate(num)
          end
        end

        SuperMathSample.new.do_work(19).should == 364
      end

      it "should be possible to override the service by setting it explicitly" do
        class SquareOverrideSample
          extend MethodDecorators

          +Requires.new(:square_service)
          def initialize
          end

          def do_work(num)
            square_service.square (num)
          end
        end

        square_service_mock = mock('SquareService', square: "square of a number")

        square_override_sample = SquareOverrideSample.new
        square_override_sample.square_service = square_service_mock
        square_override_sample.do_work(2).should == "square of a number"
      end
      
      it "should memoize the local service instance and not call the service provider twice" do
        class ServiceSample
          extend MethodDecorators

          +Requires.new(:square_service)
          def initialize
          end

          def do_work(num)
            square_service.square (num)
          end
        end
        
        ServiceProvider::Provider::Automatic.should_receive(:get_service).once.with(:square_service).and_return(SquareService.new)
        service_sample = ServiceSample.new
        service_sample.do_work(2)
        service_sample.do_work(2)
      end
    end

    context "meta-programming based injection" do
      it "should work with method based injection instead of instance based injection" do
        class MethodInjectionSample

          require_service(:square_service)


          def do_work(num)
            square_service.square (num)
          end
        end

        MethodInjectionSample.new.do_work(2).should == 4
      end

      it "should memoize the local service instance and not call the service provider twice" do
        class MethodInjectionSample

          require_service(:square_service)

          def do_work(num)
            square_service.square (num)
          end
        end
        
        ServiceProvider::Provider::Automatic.should_receive(:get_service).once.with(:square_service).and_return(SquareService.new)
        sample = MethodInjectionSample.new
        sample.do_work(2)
        sample.do_work(2)
      end
    end
  end
end

