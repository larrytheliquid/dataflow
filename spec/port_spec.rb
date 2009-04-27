require "#{File.dirname(__FILE__)}/spec_helper"

describe 'Syncronously sending to a Port' do
  it 'extends the length of the stream and preserves order' do
    local do |port, stream|
      unify port, Dataflow::Port.new(stream)
      port.send 1
      port.send 2
      stream.take(2).should == [1, 2]
      port.send 3
      stream.take(3).should == [1, 2, 3]
    end
  end
end

describe 'Asyncronously sending to a Port' do
  it 'extends the length of the stream and does not preserve order' do
    local do |port, stream|
      unify port, Dataflow::Port.new(stream)
      Thread.new {port.send 2}
      Thread.new {port.send 8}
      Thread.new {port.send 1024}
      stream.take(3).sort.should == [2, 8, 1024]
    end
  end
end
