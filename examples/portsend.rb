require "#{File.dirname(__FILE__)}/../port"
include Dataflow

local do |p, x|
  unify p, Port.new(x)
  p.send "1"
  p.send 2
  Thread.new {p.send 3}
  Thread.new { puts "x.take 5: #{x.take 5}" }
  p.send 4
  p.send "5"
  puts "x.take 1: #{x.take 1}"
end
# Give threads a chance to complete
sleep 0.1
