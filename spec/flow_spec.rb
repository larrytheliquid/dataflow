require "#{File.dirname(__FILE__)}/spec_helper"

describe 'Using flow without a parameter' do
  it 'works like normal threads' do
    local do |big_cat, small_cat|
      flow { unify big_cat, small_cat.upcase }
      unify small_cat, 'cat'
      big_cat.should == 'CAT'
    end
  end
end

describe 'Using flow with a parameter' do
  it 'binds the parameter to the last line of the block' do
    local do |big_cat, small_cat, output|
      flow(output) do
        unify big_cat, small_cat.upcase
        'returned'
      end
      unify small_cat, 'cat'
      big_cat.should == 'CAT'
      output.should == 'returned'
    end
  end
end
