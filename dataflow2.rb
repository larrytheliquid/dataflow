require 'thread'
require 'erlangprocess'

module Dataflow2
  
  def self.included(cls)
    class << cls
      def declare(*readers)
        readers.each do |name|
          variable = Variable.new
          define_method(name) { variable }
        end
      end
    end
  end
  
  def local(&block)
    vars = Array.new(block.arity) { Variable.new }
    block.call *vars
  end

  def unify(variable, value)
    variable.__unify__ value
  end

  class Variable 
    
    instance_methods.each { |m| undef_method m unless m =~ /^__/ }

    def initialize
      @Pid = ErlangProcess.new {
        requesters = []
        while 1
          msg = receive()
          case msg[0]
          when "unify" #["unify" Pid Value]
            unless defined? @value
              @value = msg[2]
              while r = requesters.shift
                r.send @value
              end
            end
            msg[1].send @value
            
          when "get" #["get" Pid]
            if @value then
              msg[1].send @value
            else
              requesters << msg[1]
            end
          end
        end
      }
    end

    def __unify__(value)
      @Pid.send ["unify", Thread.current, value]
      __value__ = Thread.current.receive()
      raise UnificationError unless __value__ == value 
      __value__
    end

    def method_missing(name, *args, &block)
      @Pid.send ["get", Thread.current]
      Thread.current.receive().__send__(name, *args, &block)
    end
  end

  UnificationError = Class.new StandardError
end
