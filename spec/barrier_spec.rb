require "#{File.dirname(__FILE__)}/spec_helper"

describe 'A barrier' do
  it 'waits for variables to be bound before continuing' do
    local do |x, y, barrier_broken|
      Thread.new do 
        barrier x, y
        unify barrier_broken, true
      end
      Thread.new { unify x, :x }
      Thread.new { unify y, :y }
      barrier_broken.should be_true
    end
  end

  it 'continues for variables that are already bound' do
    local do |x, y, barrier_broken|
      unify x, :x
      unify y, :y
      barrier x, y
      unify barrier_broken, true
      barrier_broken.should be_true
    end
  end
end
