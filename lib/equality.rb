# The purpose of this file is to make equality use method calls in as
# many Ruby implementations as possible. If method calls are used,
# then equality operations using dataflow variaables becomes seemless
# I realize overriding core classes is a pretty nasty hack, but if you
# have a better idea that also passes the equality_specs then I'm all
# ears. Please run the rubyspec before committing changes to this file.

class Object
  def ==(other)
    __id__ == other.__id__
  end
end

class Symbol
  def ==(other)
    __id__ == other.__id__
  end
end

class Regexp
  def ==(other)
    other.is_a?(Regexp) && 
    casefold? == other.casefold? &&
    kcode == other.kcode &&
    options == other.options &&
    source == other.source
  end
end
