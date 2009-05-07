require "#{File.dirname(__FILE__)}/../dataflow"
include Dataflow

local do |x, y, z|
  Fiber.new { unify x, by_need { 3 } }.resume
  Fiber.new { unify y, by_need { 4 } }.resume
  Fiber.new { unify z, x + y }.resume
  puts z
end
