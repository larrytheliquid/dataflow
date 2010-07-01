module Dataflow
  code = <<-RUBY
def map_later
  map do |x|
    Dataflow.need_later { yield x }
  end
end

def map_barrier(&blk)
  result = map_later(&blk)
  Dataflow.barrier *result
  result
end

def map_needed
  map do |x|
    Dataflow.by_need { yield x }
  end
end
RUBY

  module_eval "module Enumerable\n#{code}\n end"

  module_eval <<-RUBY
def self.enumerable!
  module_eval "module ::Enumerable\n#{code}\n end"
end
RUBY
end
