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

  describe 'when a bound variable is unified to it' do
    it 'passes unififcation for equal values' do
      local do |x|
        unify x, by_need { :a }
        unify x, :a
        x.should == :a

        y = by_need { :a }
        unify y, :a
        y.should == :a
      end
    end

    it 'fails unififcation for unequal values' do
      local do |x|
        unify x, by_need { :a }
        lambda { unify x, :b }.should raise_error(Dataflow::UnificationError)

        y = by_need { :a }
        lambda { unify y, :b }.should raise_error(Dataflow::UnificationError)
      end
    end

    describe 'when it is unified to a bound variable' do
      it 'passes unififcation for equal values' do
        local do |x|
          unify x, :a
          unify x, by_need { :a }
          x.should == :a
        end
      end
      
      it 'fails unification for unequal values' do
        local do |x|
          unify x, :a
          lambda { unify x, by_need { :b } }.should raise_error(Dataflow::UnificationError)
        end
      end
    end
  end
end
