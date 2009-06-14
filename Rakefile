require "rubygems"
require "rake/gempackagetask"
require "rake/clean"
require "spec/rake/spectask"
require File.expand_path("./dataflow")

Spec::Rake::SpecTask.new do |t|
  t.spec_opts = ['--options', "\"#{File.dirname(__FILE__)}/spec/spec.opts\""]
end

desc "Run the specs"
task :default => :spec

spec = Gem::Specification.new do |s|
  s.name           = "dataflow"
  s.version        = Dataflow::VERSION
  s.author         = "Larry Diehl"
  s.email          = "larrytheliquid" + "@" + "gmail.com"
  s.homepage       = "http://github.com/larrytheliquid/dataflow"
  s.summary        = "Dataflow concurrency for Ruby (inspired by the Oz language)"
  s.description    = s.summary
  s.files          = %w[LICENSE History.txt Rakefile README.textile dataflow.rb] + Dir["lib/**/*"] + Dir["examples/**/*"]
  s.test_files     = Dir["spec/**/*"]
end

Rake::GemPackageTask.new(spec) do |package|
  package.gem_spec = spec
end

desc 'Install the package as a gem.'
task :install => [:clean, :package] do
  gem = Dir['pkg/*.gem'].first
  sh "sudo gem install --no-rdoc --no-ri --local #{gem}"
end
