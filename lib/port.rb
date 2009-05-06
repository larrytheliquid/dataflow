module Dataflow
  class Port  
    include Dataflow

    class Stream
      include Dataflow
      declare :tail, :head
    
      # Defining each allows us to use the enumerable mixin
      # None of the list can be garbage collected less the head is
      # garbage collected, so it will grow indefinitely even though
      # the function isn't recursive.
      include Enumerable
      def each
        s = self
        loop do
          yield s.head
          s = s.tail
        end
      end

      # Backported Enumerable#take for JRuby in 1.8.6 mode
      unless method_defined?(:take)
        def take(num)
          result = []
          each_with_index do |x, i|
            return result if num == i
            result << x
          end
        end
      end
    end
  
    # Create a stream object, bind it to the input variable
    # Instance variables are necessary because @tail is state
    def initialize(x)
      @tail = Stream.new
      unify x, @tail
    end
  
    def send value
      unify @tail.head, value
      unify @tail.tail, Stream.new
      @tail = @tail.tail
    end
  end
end

