require 'monitor'

module Dataflow
  VERSION = "0.1.1"
  
  def self.included(cls)
    class << cls
      def declare(*readers)
        readers.each do |name|
          class_eval <<-RUBY
            def #{name}
              return @__dataflow_#{name}__ if defined? @__dataflow_#{name}__
              Variable::LOCK.synchronize { @__dataflow_#{name}__ ||= Variable.new }
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

  def by_need(&block)
    Variable.new &block
  end

  def need_later(&block)
    local do |future|
      Thread.new { unify future, block.call }
      future
    end
  end

  # Note that this class uses instance variables directly rather than nicely
  # initialized instance variables in get/set methods for memory and
  # performance reasons
  class Variable
    instance_methods.each { |m| undef_method m unless m =~ /^__/ }
    LOCK = Monitor.new
    def initialize(&block) @__trigger__ = block if block_given? end
    
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
          remove_instance_variable :@__binding_condition__ # GC
        end
      end
      @__value__
    end

    def __activate_trigger__
      @__value__ = @__trigger__.call
      @__bound__ = true
      remove_instance_variable :@__trigger__ # GC
    end

    def method_missing(name, *args, &block)
      LOCK.synchronize do
        unless @__bound__
          if @__trigger__
            __activate_trigger__
          else
            __binding_condition__.wait
          end
        end
      end unless @__bound__
      @__value__.__send__(name, *args, &block)
    end
  end

  UnificationError = Class.new StandardError
end

require "#{File.dirname(__FILE__)}/lib/port"
require "#{File.dirname(__FILE__)}/lib/actor"
