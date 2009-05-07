require "#{File.dirname(__FILE__)}/../dataflow"
include Dataflow

local do |x, y, z|
  Thread.new { unify x, by_need { 3 } }
  Thread.new { unify y, by_need { 4 } }
  Thread.new { unify z, x + y }
  puts z
end
