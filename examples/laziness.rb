require "#{File.dirname(__FILE__)}/../dataflow"
include Dataflow

local do |x, y, z|
  Thread.new { unify y, by_need { 4 } }
  Thread.new { unify z, x + y }
  Thread.new { unify x, by_need { 3 } }  
  puts z
end
