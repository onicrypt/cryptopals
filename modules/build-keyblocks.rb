module BuildKeyblocks
  def build_keyblocks(cipher, keyLength)
    index = 0
    keyblocks = []
    while ( (index*keyLength) + keyLength ) < cipher.bytesize do
      block = cipher.byteslice(index*keyLength, keyLength)
      keyblocks.push(block) unless block.eql?nil
      index += 1
    end
    keyblocks
  end 
end
