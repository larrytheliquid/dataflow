require "#{File.dirname(__FILE__)}/../dataflow"
include Dataflow

local do |port, stream|
  unify port, Dataflow::Port.new(stream)
  Fiber.new {port.send 2}.resume
  Fiber.new {port.send 8}.resume
  Fiber.new {port.send 1024}.resume
  puts stream.take(3).sort.inspect
end
