require 'dataflow'

module Dataflow
  module ActorModule
    # Create a new unbound dataflow variable
    def __push__
      local do |x|
        @__outerqueue__ << x 
        @__innerqueue__ << x
      end
    end
  
    def __check__
      @__outerqueue__ = [] unless defined? @__outerqueue__
      @__innerqueue__ = [] unless defined? @__innerqueue__
    end

    # Give an unbound variable to the sender
    def __getouter__
      __check__
      __push__ if @__outerqueue__.empty?
      @__outerqueue__.shift
    end

    # Give an unbound variable to the process
    def __getinner__
      __check__
      __push__ if @__innerqueue__.empty?
      @__innerqueue__.shift
    end

    def send message
      unify __getouter__, message
    end
  
    def receive
      __getinner__
    end
  end

  class Actor < Thread
    include ActorModule
    def initialize(&block)
      super { instance_eval &block }
    end
  end
end
