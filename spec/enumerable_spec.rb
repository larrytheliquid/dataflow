require "#{File.dirname(__FILE__)}/spec_helper"

describe Dataflow::Enumerable do
  it '#map_later combines map & need_later' do
    [1, 2, 3].map_later do |x|
      x.succ
    end.should == [2, 3, 4]
  end

  it '#map_barrier combines map, need_later, & barrier' do
    [1, 2, 3].map_barrier do |x|
      x.succ
    end.should == [2, 3, 4]
  end

  it '#map_needed combines map & by_need' do
    x = []
    y = []
    enum = [x, y]

    enum = enum.map_needed{|ar| ar << 1337; ar }
    
    x.should be_empty
    y.should be_empty

    enum.size.should == 2
    enum.last.should == [1337]

    x.should be_empty
    y.should == [1337]
  end
end
