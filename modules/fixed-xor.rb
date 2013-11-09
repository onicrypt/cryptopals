module FixedXOR 
  def fixed_xor(other)
    raise "Buffer lengths not equal" unless self.bytesize == other.bytesize
    #Unpack buffers into byte array and byte enum
    b1Arr = self.bytes.to_a       
    b2Enum = other.each_byte
    #XOR each Array element w/ each Enum element
    b1Arr.map! {|b| b ^ b2Enum.next}
    b1Arr.pack('C*')
  end
end
