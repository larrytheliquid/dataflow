require "#{File.dirname(__FILE__)}/../dataflow"
include Dataflow

local do |stream, doubles, triples, squares|
  unify stream, Array.new(5) { local {|v| v } }
  
  Fiber.new { unify doubles, stream.map {|n| n*2 } }.resume
  Fiber.new { unify triples, stream.map {|n| n*3 } }.resume
  Fiber.new { unify squares, stream.map {|n| n**2 } }.resume

  Fiber.new { stream.each {|x| unify x, rand(100) } }.resume

  puts "original: #{stream.inspect}"
  puts "doubles:  #{doubles.inspect}"
  puts "triples:  #{triples.inspect}"
  puts "squares:  #{squares.inspect}"  
end
