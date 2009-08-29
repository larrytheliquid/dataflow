require "#{File.dirname(__FILE__)}/../dataflow"
include Dataflow

# flow without parameters
local do |x|
  flow do 
    # other stuff
    unify x, 1337
  end
  puts x
end

# flow with an output parameter
local do |x|
  flow(x) do
    # other stuff
    1337
  end
  puts x
end
