require "#{File.dirname(__FILE__)}/spec_helper"

describe 'Using an anonymous variable' do
  it 'works with Variable instances' do
    container = [Dataflow::Variable.new]
    unify container.first, 1337
    container.first.should == 1337
  end

  it 'works with Dataflow.local' do
    container = [Dataflow.local]
    unify container.first, 1337
    container.first.should == 1337
  end

  it 'works with #local' do
    container = [local]
    unify container.first, 1337
    container.first.should == 1337
  end
end
