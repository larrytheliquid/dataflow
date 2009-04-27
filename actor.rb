require 'port'

# larrytheliquid: Note this is still experimental and not thread-safe.
# The idea will be to mimic Oz-style message passing where
# even unbound variables can be passed as messages.
module Dataflow
  class Actor < Thread
    include Dataflow
    #Instance variables aren't working properly
    #declare :port
    attr_reader :port
    attr_reader :stream

    def initialize(&block)
      @stream = Variable.new
      @port = Port.new @stream
      #unify @port, Port.new(@stream)
      super { instance_eval &block }
    end

    def send message
      port.send message
    end

    private
    def receive
      # By using an instance variable for stream, old messages
      # can be properly garbage collected. Otherwise you'd be out of luck.
      value = @stream.head
      @stream = @stream.tail
      value
    end
  end
end
