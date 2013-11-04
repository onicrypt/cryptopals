module AES_CBC 
  def cbc_encrypt(cipher, iv, blockLength)
    ##Encryption
    clearLine   = self.pkcs7_pad( blockLength )
    clearBlocks = build_keyblocks( clearLine, blockLength )
    cipherText, encrypted = "", ""
  
    clearBlocks.each_with_index { |plainChunk, i|
      cbcIn     = plainChunk.fixed_xor( iv ) if i == 0
      cbcIn     = plainChunk.fixed_xor( encrypted ) if i > 0
      encrypted = cipher.update( cbcIn ) 
      cipherText.concat( encrypted )
    }
    return cipherText
  end
  
  def cbc_decrypt(cipher, iv, blockLength)
    ##Decryption
    cipherStr    = self.pkcs7_pad( blockLength )
    cipherBlocks = build_keyblocks( cipherStr, blockLength )
    clearText    = ""
  
    cipherBlocks.each_with_index { |cipherChunk, i|
      cbcOut    = cipher.update( cipherChunk )
      decrypted = cbcOut.fixed_xor( iv ) if i == 0
      decrypted = cbcOut.fixed_xor( cipherBlocks[i-1] ) if i > 0
      clearText.concat( decrypted )
    }
    return clearText
  end
end
