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

protector = ConnectionProtector.new
19.times { Thread.new {
  protector.protect do |connection|
    puts connection.value
  end
} }

protector.protect do |connection|
  puts connection.value
end
