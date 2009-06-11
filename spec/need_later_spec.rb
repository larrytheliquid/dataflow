require "#{File.dirname(__FILE__)}/spec_helper"

describe 'A need_later expression' do
  it 'returns a future to be calculated later' do
    local do |x, y, z|
      unify y, need_later { 4 }
      unify z, need_later { x + y }
      unify x, need_later { 3 }      
      z.should == 7
    end
  end
end
