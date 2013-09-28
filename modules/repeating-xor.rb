module RepeatingXOR
  def repeating_xor(key)
    bytes = self.bytes
    key = key.bytes
    bytes.each_with_index {|item, index| 
      key_index = index % key.size
      bytes[index] = item ^ key[key_index]
    }
    bytes.pack('C*')
  end
end
