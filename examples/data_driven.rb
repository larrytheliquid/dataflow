require "#{File.dirname(__FILE__)}/../dataflow"
include Dataflow

local do |stream, doubles, triples, squares|
  unify stream, Array.new(5) { Dataflow::Variable.new }
  
  Thread.new { unify doubles, stream.map {|n| n*2 } }
  Thread.new { unify triples, stream.map {|n| n*3 } }
  Thread.new { unify squares, stream.map {|n| n**2 } }  

  Thread.new { stream.each {|x| unify x, rand(100) } }

  puts "original: #{stream.inspect}"
  puts "doubles:  #{doubles.inspect}"
  puts "triples:  #{triples.inspect}"
  puts "squares:  #{squares.inspect}"  
end
