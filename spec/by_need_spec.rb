require "#{File.dirname(__FILE__)}/spec_helper"

describe 'A by_need trigger' do
  it 'creates a need when a method is called on it' do
    local do |x, y, z|
      Thread.new { unify y, by_need { 4 } }
      Thread.new { unify z, x + y }
      Thread.new { unify x, by_need { 3 } }      
      z.should == 7
    end
  end
end
