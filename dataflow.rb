require 'monitor'

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
    instance_methods.each { |m| undef_method m unless m =~ /^__/ }
    LOCK = Monitor.new
    def initialize
      @__binding__ = LOCK.new_cond
    end

    def __unify__(value)
      LOCK.synchronize do
        if @__value__
          raise UnificationError  if @__value__ != value
        else
          @__value__ = value
          @__binding__.broadcast # wakeup all method callers
          @__binding__ = nil # garbage collect condition
        end
      end
      @__value__
    end

    def method_missing(name, *args, &block)
      # double-checked race condition to avoid going into synchronize
      LOCK.synchronize do
        @__binding__.wait unless @__value__
      end unless @__value__ 
      @__value__.__send__(name, *args, &block)
    end
  end

  UnificationError = Class.new StandardError
end
