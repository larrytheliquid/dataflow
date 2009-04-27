require "#{File.dirname(__FILE__)}/../dataflow"
include Dataflow

local do |port, stream|
  unify port, Dataflow::Port.new(stream)
  Thread.new {port.send 2}
  Thread.new {port.send 8}
  Thread.new {port.send 1024}
  puts stream.take(3).sort.inspect
end
