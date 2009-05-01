require "#{File.dirname(__FILE__)}/../dataflow"
include Dataflow

local do |x, y, z|
  # notice how the order automatically gets resolved
  Fiber.new { unify y, x + 2 }.resume
  Fiber.new { unify z, y + 3 }.resume
  Fiber.new { unify x, 1 }.resume
  puts z
end
  
