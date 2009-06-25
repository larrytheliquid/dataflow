require "#{File.dirname(__FILE__)}/spec_helper"

describe 'Syncronously sending to an Actor' do  
  it 'passes in each message received and preserves order' do
    local do |port, stream, actor|
      unify port, Dataflow::Port.new(stream)
      unify actor, Dataflow::Actor.new { 3.times { port.send receive } }
      actor.send 1
      actor.send 2
      stream.take(2).should == [1, 2]
      actor.send 3
      stream.take(3).should == [1, 2, 3]
    end
  end
end

describe 'Asyncronously sending to an Actor' do
  it 'passes in each message received and preserves order' do
    local do |port, stream, actor|
      unify port, Dataflow::Port.new(stream)
      unify actor, Dataflow::Actor.new { 3.times { port.send receive } }
      Thread.new {actor.send 2}
      Thread.new {actor.send 8}
      Thread.new {actor.send 1024}
      stream.take(3).sort.should == [2, 8, 1024]      
    end
  end
end
