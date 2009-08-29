require "#{File.dirname(__FILE__)}/../dataflow"
include Dataflow

local do |queue, first, second|
  unify queue, Dataflow::FutureQueue.new
  queue.pop first
  queue.push 1
  queue.push 2
  queue.pop second
  puts "first:  #{first}, second: #{second}"
end
