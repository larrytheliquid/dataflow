require 'port'

module Dataflow
  class Actor < Thread
    include Dataflow
    #Instance variables aren't working properly
    #declare :stream, :port
    attr_reader :stream, :port

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
      value = @stream.head
      stream = @stream.tail
      value
    end
  end
end
