require "#{File.dirname(__FILE__)}/../dataflow"
require 'net/http'
include Dataflow

# Be gentle running this one
Thread.abort_on_exception = true
local do |stream, branding_occurences, number_of_mentions|
  unify stream, Array.new(10) { need_later { Net::HTTP.get_response(URI.parse("http://www.cuil.com/search?q=#{rand(1000)}")).body } }
  unify branding_occurences, need_later { stream.map {|http_body| http_body.scan /cuil/ } }
  unify number_of_mentions, need_later { branding_occurences.map {|occurences| occurences.length } }
  puts number_of_mentions.inspect
end
