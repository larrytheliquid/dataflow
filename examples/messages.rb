require "#{File.dirname(__FILE__)}/../erlangprocess"

Ping = ErlangProcess.new {
  3.times {
    msg = receive
    case msg
    when "Ping"
      puts "Ping"
      Pong.send "Pong"
    end
  }
}

Pong = ErlangProcess.new {
  3.times {
    msg = receive
    case msg
    when "Pong"
      puts "Pong"
      Ping.send "Ping"
    end
  }
}

ErlangProcess.new {
  send "Hi"
  puts "Received: #{receive}"
  Ping.send "Ping"
}

sleep 1