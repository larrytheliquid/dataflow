require 'monitor'

module Dataflow
  VERSION = "0.3.1"
  class << self
    attr_accessor :forker
  end
  self.forker = Thread.method(:fork)
  
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
    return Variable.new unless block_given?
    vars = Array.new(block.arity) { Variable.new }
    block.call *vars
  end

  def unify(variable, value)
    variable.__unify__ value
  end

  def by_need(&block)
    Variable.new &block
  end

  def barrier(*variables)
    variables.each{|v| v.__wait__ }
  end

  def flow(output=nil, &block)
    Dataflow.forker.call do
      result = block.call
      unify output, result if output
    end
  end

  def need_later(&block)
    local do |future|
      flow(future) { block.call }
      future
    end
  end

  extend self

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
        __activate_trigger__ if @__trigger__
        if @__bound__
          return @__value__.__unify__(value) if @__value__.__dataflow__? rescue nil
          raise UnificationError, "#{@__value__.inspect} != #{value.inspect}" if self != value
        else
          @__value__ = value
          @__bound__ = true
          __binding_condition__.broadcast # wakeup all method callers
          @__binding_condition__ = nil # GC
        end
      end
      @__value__
    end

    def __activate_trigger__
      @__value__ = @__trigger__.call
      @__bound__ = true
      @__trigger__ = nil # GC
    end

    def __wait__
      LOCK.synchronize do
        unless @__bound__          
          if @__trigger__
            __activate_trigger__
          else
            __binding_condition__.wait
          end
        end
      end unless @__bound__
    end

    def method_missing(name, *args, &block)
      return "#<Dataflow::Variable:#{__id__} unbound>" if !@__bound__ && name == :inspect
      __wait__
      @__value__.__send__(name, *args, &block)
    end

    def __dataflow__?
      true
    end
  end

  UnificationError = Class.new StandardError
end

require "#{File.dirname(__FILE__)}/dataflow/port"
require "#{File.dirname(__FILE__)}/dataflow/actor"
require "#{File.dirname(__FILE__)}/dataflow/future_queue"
