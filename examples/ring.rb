require "#{File.dirname(__FILE__)}/../dataflow"
include Dataflow

# Send M messages each along a ring of N nodes
N = 4
M = 2

actors = []
N.times do |n| 
  actors[n] = Variable.new 
end

N.times do |n|
  unify actors[n], Actor.new {
    M.times do |m|
      receive
      puts "[#{n} #{m}]"
      actors[(n+1) % N].send :msg
    end
    puts "[#{n}] done"
  }
end

actors[0].send :msg
