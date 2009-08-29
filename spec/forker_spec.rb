require "#{File.dirname(__FILE__)}/spec_helper"

describe 'Setting a customer forker' do
  before(:all) do
    @original_forker = Dataflow.forker
    Dataflow.forker = Class.new do
      def self.synchronous_forker(&block)
        block.call
      end
    end.method(:synchronous_forker)
  end

  after(:all) do
    Dataflow.forker = @original_forker
  end
  
  it 'uses the custom forker in #flow' do
    local do |my_var|
      flow(my_var) { 1337 }
      my_var.should == 1337
    end
  end

  it 'uses the custom forker in #need_later' do
    my_var = need_later { 1337 }
    my_var.should == 1337
  end
end
