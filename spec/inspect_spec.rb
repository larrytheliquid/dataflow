require "#{File.dirname(__FILE__)}/spec_helper"

describe "An unbound variable" do
  it "should be inspectable for debugging purposes" do
    local do |unbound|
      unbound.inspect.should == "#<Dataflow::Variable unbound>"
    end
  end
end

describe "An bound variable" do
  it "should proxy inspect" do
    local do |bound|
      bound.inspect
      unify bound, "str"
      bound.should == "str"
    end
  end
end
