require "#{File.dirname(__FILE__)}/../dataflow"
require 'net/http'
include Dataflow

# Be gentle running this one
local do |stream, branding_occurences, number_of_mentions|
  unify stream, Array.new(10) { Dataflow::Variable.new }
  stream.each {|s| Fiber.new { unify s, Net::HTTP.get_response(URI.parse("http://www.cuil.com/search?q=#{rand(1000)}")).body }.resume }
  Fiber.new { unify branding_occurences, stream.map {|http_body| http_body.scan /cuil/ } }.resume
  Fiber.new { unify number_of_mentions, branding_occurences.map {|occurences| occurences.length } }.resume
  puts number_of_mentions.inspect
end
