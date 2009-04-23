module Dataflow
  class Store
    def initialize
      @store = {}
    end

    def [](variable)
      @store[variable]
    end

    def []=(variable, value)
      if existing_value = @store[variable]
        raise UnificationError unless value == existing_value
      else
        @store[variable] = value        
      end
    end

    UnificationError = Class.new StandardError
  end
end
