require 'port'

module Dataflow
  class Actor < Thread
    include Dataflow
    declare :port
    # An instance variable is needed for stream.
    attr_reader :stream

    def initialize(&block)
      @stream = Variable.new
      unify port, Port.new(@stream)
      # Run this block in a new thread
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
