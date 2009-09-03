require "#{File.dirname(__FILE__)}/../dataflow"

class ThreadUnsafeConnection
  def initialize() @used = 0 end

  def value
    @used += 1
  end
end

class ConnectionProtector
  def initialize
    @queue = Dataflow::FutureQueue.new
    @queue.push ThreadUnsafeConnection.new
  end

  def protect(&block)
    Dataflow.local do |connection|
      @queue.pop connection
      block.call connection
      @queue.push connection
    end
  end
end

def self.sometimes(num, connection)
  if num%2 == 0
    "#{num}:#{connection.value}"
  else
    "connection not used!"
  end
end

protector = ConnectionProtector.new
19.times {|i| Thread.new {
  protector.protect do |connection|
    puts sometimes(i, connection)
  end
} }
 
protector.protect do |connection|
  puts sometimes(20, connection)
end
