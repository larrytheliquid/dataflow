module Dataflow
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
      @__requesters__ = []
    end

    def __unify__(value)
      raise UnificationError if @__value__ && @__value__ != value
      @__value__ = value
      @__requesters__.each do |r|
        r.wakeup if r.status == 'sleep'
      end
      @__requesters__ = []
      @__value__
    end
    
    def method_missing(name, *args, &block)
      if !@__value__
        @__requesters__ << Thread.current
        sleep
      end
      @__value__.__send__(name, *args, &block)
    end
  end

  UnificationError = Class.new StandardError
end
