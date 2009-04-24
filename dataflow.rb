module Dataflow
  def local(&block)
    vars = Array.new(block.arity) { Variable.new }
    block.call *vars
  end
  
  def unify(variable, value)
    if existing_value = variable.__value__
      raise UnificationError unless value == existing_value
    else
      variable.__value__ = value
    end
  end

  class Variable
    instance_methods.each { |m| undef_method m unless m =~ /^__/ }
    attr_accessor :__value__
    
    def method_missing(name, *args, &block)
      __value__.__send__(name, *args, &block)
    end
  end

  UnificationError = Class.new StandardError
end
