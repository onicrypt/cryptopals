module HammingDistance
  def hamming_distance(other)
    raise "Buffer lengths not equal" unless self.bytesize == other.bytesize
    bits1, bits2, res = [], [], []
    #Break down strings into arrays of bits
    string1 = self.unpack('b*').join
    string1.each_char{|bit| bits1.push( bit.to_i(2) )}
    string2 = other.unpack('b*').join
    string2.each_char{|bit| bits2.push( bit.to_i(2) )}
    #XOR respective bits in both arrays
    bits1.each_with_index {|bit, index| res.push ( bit ^ bits2[index] )}
    #Return the sum
    res.reduce(:+)
  end 
end
