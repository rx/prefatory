module Prefatory
  module Keys
    INCR_KEY = 'prefatory'.freeze

    def build_key(obj=nil,value=nil, prefix=nil)
      klass = nil
      klass = obj&.class == 'Class' ? obj.name.downcase : obj&.class.name.downcase   if obj
      "#{INCR_KEY}#{prefix ? ":#{prefix}" : nil}#{klass ? ":#{klass}" : nil}#{value ? ":#{value}" : nil}"
    end
  end
end
