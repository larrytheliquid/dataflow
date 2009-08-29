module Dataflow
  class FutureQueue
    include Dataflow
    declare :push_port, :pop_port
    
    def initialize
      local do |pushed, popped|
        unify push_port, Dataflow::Port.new(pushed)
        unify pop_port, Dataflow::Port.new(popped)
        
        Thread.new {
          loop do
            barrier pushed.head, popped.head
            unify popped.head, pushed.head
            pushed, popped = pushed.tail, popped.tail
          end
        }
      end
    end

    def push(x) push_port.send x end
    def pop(x) pop_port.send x end
  end
end
