module PKCS7
  def convert_base(from, to)
    self.to_i(from).to_s(to)
  end

  def pkcs7_pad(blockLength)
    ptLength  = self.length
    padLen    = 0
    remainder = ptLength % blockLength
    padLen    = blockLength - remainder unless ( remainder == 0 )
    padStr    = [padLen.to_s.convert_base(10, 16)].pack('H*')
    for i in 0...padLen do
      self.concat( padStr )
    end
    return self
  end
end
