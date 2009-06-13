require "#{File.dirname(__FILE__)}/../dataflow"
include Dataflow

Ping = Actor.new {
  3.times {
    case receive
    when "Ping"
      puts "Ping"
      Pong.send "Pong"
    end
  }
}

Pong = Actor.new {
  3.times {
    case receive
    when "Pong"
      puts "Pong"
      Ping.send "Ping"
    end
  }
}

Ping.send "Ping"
Ping.join
Pong.join
