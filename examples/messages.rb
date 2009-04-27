require "#{File.dirname(__FILE__)}/../actor"

include Dataflow

Ping = Actor.new {
  3.times {
    msg = receive
    case msg
    when "Ping"
      puts "Ping"
      Pong.send "Pong"
    end
  }
}

Pong = Actor.new {
  3.times {
    msg = receive
    case msg
    when "Pong"
      puts "Pong"
      Ping.send "Ping"
    end
  }
}

Actor.new {
  send "Hi"
  puts "Received: #{receive}"
  Ping.send "Ping"
}

sleep 1