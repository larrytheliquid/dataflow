require "#{File.dirname(__FILE__)}/../dataflow"
include Dataflow

local do |lock1, lock2|
  flow { unify lock1, :unlocked }
  flow { unify lock2, :unlocked }
  barrier lock1, lock2
  puts "Barrier broken!"  
end
