module KeyGen
  class Key < Array
    attr_reader :key
    def initialize
      @key = []
    end

    def low_alpha
      if @key.empty? 
        @key = ('a'..'z').to_a 
      else 
        ('a'..'z').each{|a| @key.push(a)}
        @key
      end
    end

    def high_alpha
      if @key.empty? 
        @key = ('A'..'Z').to_a 
      else 
        ('A'..'Z').each{|a| @key.push(a)}
        @key
      end
    end

    def alpha_num
      self.low_alpha
      self.high_alpha 
      ('0'..'9').each{|n| @key.push(n)}
      @key
    end

    def special
      sp = ['!','@','#','$','%','^','&','*','(',')',
            '{','|','\\','"',':',';','/','.',',','<',
            '>','?','`','~','-','=','_','+'] 
      if @key.empty? 
        @key = sp 
      else 
        sp.each {|s| @key.push(s)} 
        @key
      end 
    end
  end
end
