require 'rubygems'
require 'spec'
require "#{File.dirname(__FILE__)}/../dataflow"

Thread.abort_on_exception = true

Spec::Runner.configure do |config|
  config.include Dataflow
end
