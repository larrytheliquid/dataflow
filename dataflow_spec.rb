require 'rubygems'
require 'spec'
require 'dataflow'

module Dataflow
  describe 'A new Store' do
    before { @store = Store.new }
    
    it 'should bind an unbound variable on unification' do
      @store[:var] = 'cat'
      @store[:var].should == 'cat'
    end

    it 'should not complain when unifying a bound variable with an equal object' do
      lambda do
        @store[:var] = 'cat'
        @store[:var] = 'cat'
      end.should_not raise_error
    end

    it 'should complain when unifying a bound variable with an unequal object' do
      lambda do
        @store[:var] = 'cat'
        @store[:var] = 'dog'
      end.should raise_error(Store::UnificationError)
    end
  end
end
