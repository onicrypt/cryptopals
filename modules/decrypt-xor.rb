require "bigdecimal"

module Decrypt_XOR
  class DecryptXOR < Hash
    attr_accessor :digest                                                         
    attr_reader :key_vals, :clear_string, :found_key, :found_index, :max_score
    def initialize(digest, keyVals)
      @digest = digest
      @key_vals = keyVals
    end
  
    def new_digest(newDigest)
      @digest = newDigest
      #Delete all entries to remove scores
      self.delete_if{|key, value| key === key}
    end
   
    def init_frequency
      init_freq = {}
      init_freq[' '] = 19.03 
      init_freq['e'] = 12.70 
      init_freq['t'] =  9.06
      for num in '0'..'9' do
        init_freq[num] = 8.50
      end
      init_freq['a'] =  8.17 
      init_freq['o'] =  7.51 
      init_freq['i'] =  6.96 
      init_freq['n'] =  6.75 
      init_freq['s'] =  6.33 
      init_freq['h'] =  6.09
      init_freq['r'] =  5.99
      init_freq['d'] =  4.25
      init_freq['l'] =  4.03
      init_freq['c'] =  2.78
      init_freq['u'] =  2.76
      init_freq['m'] =  2.41
      init_freq['w'] =  2.36
      init_freq['f'] =  2.23
      init_freq['g'] =  2.02
      init_freq['y'] =  1.97
      init_freq['p'] =  1.93
      init_freq['b'] =  1.49
      init_freq['v'] =  0.98
      init_freq['k'] =  0.77
      init_freq['j'] =  0.15
      init_freq['x'] =  0.15
      init_freq['q'] =  0.10
      init_freq['z'] =  0.07
      return init_freq
    end

    def init_count(text)
      #Switch to lower case to regularize comparisons
      text_low = text.downcase
  
      #Store count for each char in string  
      count = {}
      for letter in 'a'..'z' do
        count[letter] = text_low.count(letter)
      end
  
      for num in '0'..'9' do
        count[num] = text_low.count(num)
      end

      count[' '] = text_low.count(' ')
      return count
    end

    def frequency_score(count, length)
      char_freq = {}
      count.each {|char, hits|
        char_freq[char] = (hits / BigDecimal(length)) * 100
      }
  
      #Add 1 to score if character frequencies match expected values
      score = 0
      stdev = BigDecimal("1.36")
      exp_freq = init_frequency()
      char_freq.each_key {|char|
        delta_hi = exp_freq[char] + stdev
        delta_lo = exp_freq[char] - stdev
        
        if (char_freq[char] <= delta_hi) && (char_freq[char] >= delta_lo)
             score += 1 
        end
      }

      return score
    end
  
    def decrypt
      #XOR each key value with digest
      #Give each a default score of zero
      @key_vals.each {|k| self[@digest.sc_xor(k)] = 0}
  
      self.each {|line, score| 
        #skip strings containing non-ASCII chars
        next unless line.ascii_only? 
    
        #Score line based on letter frequency
        char_count = init_count(line)
        length = line.size
        score = frequency_score(char_count, length)
        
        #check for conditions less likely in an English string of text
        #Lower-case letter followed by upper-case letter 2+ times
        if line.match(/[a-z][A-Z]{2,}/)         then score -= 5 end
        #Letter followed by a non-word/space char followed by a letter
        if line.match(/[a-zA-Z][^\w ][a-zA-Z]/) then score -= 5 end 
        #Letter followed by number followed by letter
        if line.match(/[a-zA-Z][0-9][a-zA-Z]/)  then score -= 5 end 
        #A non-word/space/punctuation character was found
        if line.match(/[^a-zA-Z0-9 .,!'?]/)     then score -= 5 end 
        #Zero non-word/space characters
        if line.match(/[^a-zA-Z0-9_ ]/) == nil  then score += 5 end  
        
        self[line] = score
      }
    end
  
    def get_results
      return nil unless self.values
      #Convert Hash to Array
      #Makes finding correct key index easier
      candidates_array = self.to_a
      @max_score = self.values.max
  
      candidates_array.each_with_index {|string, index|
        if string[1] == @max_score
          @found_index = index 
          @clear_string = string[0]
        end 
      }
  
      (@found_key = @key_vals[@found_index]) unless @found_index.nil?
    end
  end
end
