require "spec_helper"
require "service_provider/method_decorators/requires"
require "service_provider/method_decorators/provides"


describe ServiceProvider do
  describe "providing a simople service" do
    it "should work" do
      class SquareService
        extend MethodDecorators

        +Provides.new(:square_service)
        def initialize
          puts "init the SquareService"
        end

        def square(num)
          num * num
        end

        include ServiceProvider
      end
      
      class Sample
        extend MethodDecorators

        +Requires.new(:square_service)
        def initialize
          puts "init the Sample"
        end

        def do_work(num)
          @square_service.square  (num)
        end
      end

      Sample.new.do_work(2).should == 4
    end
  end
end

