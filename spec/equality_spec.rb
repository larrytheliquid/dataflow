require "#{File.dirname(__FILE__)}/spec_helper"

describe 'Unifying a bound value to an object of equal value' do
  describe 'for classes that define == to perform method calls on the RHS' do
    it 'passes unification' do
      local do |var, var2|
        unify var, "str"
        var.should == "str"
        "str".should == var
        lambda {unify var, "str"}.should_not raise_error

        unify var2, "str"
        var.should == var2
        var2.should == var
        lambda {unify var, var2}.should_not raise_error        
      end
    end
  end
  
  describe 'for classes that do not define == to perform method calls on the RHS' do    
    it 'passes unification' do
      local do |var, var2|
        unify var, :sym
        var.should == :sym
        lambda {unify var, :sym}.should_not raise_error

        unify var2, :sym
        var.should == var2
        var2.should == var
        lambda {unify var, var2}.should_not raise_error
      end
    end
  end
end
