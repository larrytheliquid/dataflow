module Dataflow
  class Actor < Thread
    def initialize(&block)
      @stream = Variable.new
      @port = Port.new(@stream)
      # Run this block in a new thread
      super { instance_eval &block }
    end

    def send message
      @port.send message
    end

  private
    
    def receive
      result = @stream.head
      @stream = @stream.tail
      result
    end
  end
end
