require "#{File.dirname(__FILE__)}/spec_helper"

describe 'A by_need expression' do
  describe 'when a method is called on it' do
    it 'binds its variable' do
      local do |x, y, z|
        Thread.new { unify y, by_need { 4 } }
        Thread.new { unify z, x + y }
        Thread.new { unify x, by_need { 3 } }
        z.should == 7
      end
    end
  end

  describe 'when it is unified to a bound variable' do
    it 'passes unififcation for equal values' do
      local do |x|
        unify x, by_need { 3 }
        unify x, 3
        x.should == 3
      end
    end

    it 'fails unififcation for unequal values' do
      local do |x|
        unify x, by_need { 3 }
        lambda { unify x, 3 }.should raise_error(Dataflow::UnificationError)
      end
    end

    describe 'when a bound variable is unified to it' do
      it 'passes unififcation for equal values' do
        local do |x|
          unify x, 3
          unify x, by_need { 3 }
          x.should == 3
        end
      end
      
      it 'fails unification for unequal values' do
        local do |x|
          unify x, 3
          lambda { unify x, by_need { 3 } }.should raise_error(Dataflow::UnificationError)
        end
      end
    end
  end
end
