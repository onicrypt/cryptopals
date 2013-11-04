module BuildKeyblocks
  def build_keyblocks(cipher, blockLength)
    index = 0
    keyblocks = []
    cipherLength = cipher.bytesize
    blockCount = (cipherLength / Float(blockLength)).ceil
    
    while index < blockCount do
      blockIndex = index * blockLength
      block = cipher.byteslice(blockIndex, blockLength)
      keyblocks.push(block) unless block.eql?nil
      index += 1
    end
    
    keyblocks
  end 
end
