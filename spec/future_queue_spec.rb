require "#{File.dirname(__FILE__)}/spec_helper"

describe 'A future queue' do
  it 'accepts synchronous pushes and pops' do
    local do |queue, first, second, third|
      unify queue, Dataflow::FutureQueue.new
      queue.pop first
      queue.pop second
      queue.push 1
      queue.push 2
      queue.push 3
      queue.pop third  

      [first, second, third].should == [1, 2, 3]
    end
  end

  it 'accepts asynchronous pushes and pops' do
    local do |queue, first, second, third|
      unify queue, Dataflow::FutureQueue.new
      Thread.new { queue.pop first }
      Thread.new { queue.pop second }
      Thread.new { queue.push 1 }
      Thread.new { queue.push 2 }
      Thread.new { queue.push 3 }
      Thread.new { queue.pop third }

      [first, second, third].sort.should == [1, 2, 3]
    end
  end
end
