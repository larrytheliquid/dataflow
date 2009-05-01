require 'fiber'

module Dataflow
  def self.included(cls)
    class << cls
      def declare(*readers)
        readers.each do |name|
          class_eval <<-RUBY
            def #{name}
              @__dataflow_#{name}__ ||= Variable.new
            end
          RUBY
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

  # Note that this class uses instance variables rather than nicely
  # initialized instance variables in get/set methods for memory and
  # performance reasons
  class Variable
    instance_methods.each { |m| undef_method m unless m =~ /^__/ }
    # Lazy-load callers to be nice on memory usage
    def __callers__() @__callers__ ||= Array.new end

    def __unify__(value)
      if @__bound__
        raise UnificationError if @__value__ != value
      else
        @__value__ = value
        @__bound__ = true
        while caller = __callers__.shift
          caller.resume
        end
      end
      @__value__
    end

    def method_missing(name, *args, &block)
      unless @__bound__
        __callers__ << Fiber.current
        Fiber.yield
      end
      @__value__.__send__(name, *args, &block)
    end
  end

  UnificationError = Class.new StandardError
end

# require "#{File.dirname(__FILE__)}/lib/port"
# require "#{File.dirname(__FILE__)}/lib/actor"
