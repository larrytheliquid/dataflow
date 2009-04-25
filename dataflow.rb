require 'thread'

module Dataflow
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
    MUTEX = Mutex.new
    instance_methods.each { |m| undef_method m unless m =~ /^__/ }
    def initialize
      @__requesters__ = []
    end

    def __unify__(value)
      MUTEX.synchronize do
        raise UnificationError if @__value__ && @__value__ != value
        @__value__ = value
        while r = @__requesters__.shift
          r.wakeup if r.status == 'sleep'
        end
        @__value__
      end
    end

    def method_missing(name, *args, &block)
      MUTEX.synchronize do
        @__requesters__ << Thread.current unless @__value__
      end
      sleep unless @__value__
      @__value__.__send__(name, *args, &block)
    end
  end

  UnificationError = Class.new StandardError
end
