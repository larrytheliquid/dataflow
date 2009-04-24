require 'rubygems'
require 'spec'
require 'dataflow'

Spec::Runner.configure do |config|
  config.include Dataflow
end


describe 'A new Variable' do
  it 'should suspend if an unbound variable has a method called on it' do
    pending
  end
  
  it 'should bind an unbound variable on unification' do
    local do |var|
      unify var, 'cat'
      var.should == 'cat'
    end
  end

  it 'should not complain when unifying a bound variable with an equal object' do
    lambda do
      local do |var|
        unify var, 'cat'
        unify var, 'cat'        
        var.should == 'cat'
      end
    end.should_not raise_error
  end

  it 'should complain when unifying a bound variable with an unequal object' do
    lambda do
      local do |var|
        unify var, 'cat'
        unify var, 'dog'
        var.should == 'cat'
      end
    end.should raise_error(Dataflow::UnificationError)
  end
end
