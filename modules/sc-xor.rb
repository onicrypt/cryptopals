module SingleCharXOR
  def sc_xor(key)
    stringBytes = self.bytes
    key = key.bytes
    stringBytes.map! {|item| item ^ key.first}
    stringBytes.pack('C*')
  end
end
