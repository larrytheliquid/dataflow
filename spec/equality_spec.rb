require "#{File.dirname(__FILE__)}/spec_helper"

describe 'Unifying a bound value' do
  [3, 2.0, Object.new, Class.new.new, "str", :sym, /abc/].each do |type|
    describe "for #{type.class} instances" do
      it 'passes unification for an object of equal value' do
        local do |var, var2|
          unify var, type
          var.should == type
          type.should == var
          lambda {unify var, type}.should_not raise_error

          unify var2, type
          var.should == var2
          var2.should == var
          lambda {unify var, var2}.should_not raise_error        
        end
      end

      it 'fails unification for an object of inequal value' do
        different = Object.new
        local do |var, var2|
          unify var, different
          var.should != different
          different.should != var
          lambda {unify var, different}.should raise_error(Datatalow::UnificationError)

          unify var2, different
          var.should != var2
          var2.should != var
          lambda {unify var, var2}.should_not raise_error(Datatalow::UnificationError)
        end
      end
    end
  end
end
