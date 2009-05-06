require "#{File.dirname(__FILE__)}/../dataflow"
require 'net/http'
include Dataflow

# Be gentle running this one
local do |port, stream, branding_occurences, number_of_mentions|
  unify port, Dataflow::Port.new(stream)
  10.times { Fiber.new { port.send Net::HTTP.get_response(URI.parse("http://www.cuil.com/search?q=#{rand(1000)}")).body }.resume }
  Fiber.new { unify branding_occurences, stream.take(10).map {|http_body| http_body.scan /cuil/ } }.resume
  Fiber.new { unify number_of_mentions, branding_occurences.map {|occurences| occurences.length } }.resume
  puts number_of_mentions.inspect
end
