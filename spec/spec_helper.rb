require 'rubygems'
require 'spec'
require 'dataflow'

Thread.abort_on_exception = true

Spec::Runner.configure do |config|
  config.include Dataflow
end
