require "#{File.dirname(__FILE__)}/../actor"
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

Actor.new { Ping.send "Ping" }

Ping.join
Pong.join
