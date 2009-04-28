require "#{File.dirname(__FILE__)}/../dataflow"
require 'net/http'
include Dataflow

# Be gentle running this one
Thread.abort_on_exception = true
local do |stream, branding_occurences, number_of_mentions|
  unify stream, Array.new(100) { Dataflow::Variable.new }
  stream.each {|s| Thread.new(s) {|v| unify v, Net::HTTP.get_response(URI.parse("http://www.cuil.com/search?q=#{rand(1000)}")).body } }
  Thread.new { unify branding_occurences, stream.map {|http_body| http_body.scan /cuil/ } }
  Thread.new { unify number_of_mentions, branding_occurences.map {|googles| googles.length } }
  puts number_of_mentions.inspect
end
