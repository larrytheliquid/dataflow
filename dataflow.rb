require 'monitor'

module Dataflow
  def self.included(cls)
    class << cls
      def declare(*readers)
        readers.each do |name|
          class_eval <<-RUBY
            def #{name}
              @__ivar_#{name}__ ||= Variable.new
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
    LOCK = Monitor.new
    # Lazy-load conditions to be nice on memory usage
    def __binding_condition__() @__binding_condition__ ||= LOCK.new_cond end

    def __unify__(value)
      LOCK.synchronize do
        if @__bound__
          raise UnificationError if @__value__ != value
        else
          @__value__ = value
          @__bound__ = true
          __binding_condition__.broadcast # wakeup all method callers
          @__binding_condition__ = nil # garbage collect condition
        end
      end
      @__value__
    end

    def method_missing(name, *args, &block)
      LOCK.synchronize do
        __binding_condition__.wait unless @__bound__
        # TODO: Cache a instance_eval'd method on this object
      end
      @__value__.__send__(name, *args, &block)
    end
  end

  UnificationError = Class.new StandardError
end
