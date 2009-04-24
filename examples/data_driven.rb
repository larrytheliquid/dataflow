require "#{File.dirname(__FILE__)}/../dataflow"
include Dataflow

local do |stream|
  unify stream, Array.new(5) { local {|v| v } }
  Thread.new { stream.each_with_index {|n, i| puts "echo client #{i+1}: #{n}" } }
  Thread.new { stream.each_with_index {|n, i| puts "double client #{i+1}: #{n*2}" } }

  stream.each do |x|
    unify x, rand(100)
    sleep 2
  end
end
