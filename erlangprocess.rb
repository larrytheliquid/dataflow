require 'dataflow'
include Dataflow

class ErlangProcess
    
  def initialize(&block)
    @__outerqueue__ = []
    @__innerqueue__ = []
    Thread.new { instance_eval(&block) }
  end
  
  # Create a new unbound dataflow variable
  def __push__
    local do |x| 
      @__outerqueue__ << x 
      @__innerqueue__ << x
    end
  end
  
  # Give an unbound variable to the sender
  def __getouter__
    __push__ if @__outerqueue__.empty?
    @__outerqueue__.shift
  end
  
  # Give an unbound variable to the process
  def __getinner__
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
