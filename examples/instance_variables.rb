require "#{File.dirname(__FILE__)}/../dataflow"

class AnimalHouse
  include Dataflow
  declare :small_cat, :big_cat

  def fetch_big_cat
    Thread.new { unify big_cat, small_cat.upcase }
    unify small_cat, 'cat'
    big_cat
  end
end

puts AnimalHouse.new.fetch_big_cat

