require "openssl"
require "modules/hex-b64"
require "modules/pkcs7"
require "modules/build-keyblocks"
require "modules/fixed-xor"

include BuildKeyblocks

class String
  include PKCS7
  include HexBase64
  include FixedXOR
end

module AES_EXTENDS
  def gen_rand_key
    key = ""
    16.times do key += rand(256).chr end
    key
  end

  def ecb_encrypt(clear, key)
	  if (key.length * 8) == 128 or (key.length * 8) == 256
		  keysize = key.length * 8
	  else
		  return nil
	  end
	  cipher = OpenSSL::Cipher::AES.new(keysize, :ECB)
	  cipher.encrypt
	  cipher.key = key
	  cipher.update(clear) + cipher.final
  end

  def ecb_decrypt(cipher, key)
  	if (key.length * 8) == 128 or (key.length * 8) == 256
  	  keysize = key.length * 8
  	else
  	  return nil
  	end
  	decipher = OpenSSL::Cipher::AES.new(keysize, :ECB)
  	decipher.decrypt
  	decipher.key = key
  	decipher.update(cipher) + decipher.final
  end
  
  def cbc_encrypt(cipher_str, cipher, iv, blockLength)
    ##Encryption
    clearLine   = cipher_str.pkcs7_pad( blockLength )
    clearBlocks = build_keyblocks( clearLine, blockLength )
    cipherText, encrypted = String.new(""), String.new("")
  
    clearBlocks.each_with_index { |plainChunk, i|
      cbcIn     = plainChunk.fixed_xor( iv ) if i == 0
      cbcIn     = plainChunk.fixed_xor( encrypted ) if i > 0
      encrypted = cipher.update( cbcIn ) 
      cipherText.concat( encrypted )
    }
    return cipherText
  end
  
  def cbc_decrypt(cipher_str, cipher, iv, blockLength)
    ##Decryption
    cipherStr    = cipher_str
    cipherBlocks = build_keyblocks( cipherStr, blockLength )
    clearText    = String.new("")
  
    cipherBlocks.each_with_index { |cipherChunk, i|
      cbcOut    = cipher.update( cipherChunk )
      decrypted = cbcOut.fixed_xor( iv ) if i == 0
      decrypted = cbcOut.fixed_xor( cipherBlocks[i-1] ) if i > 0
      clearText.concat( decrypted )
    }
    return clearText
  end

  def encryption_oracle(input)
    length = 16
    (0..(rand(5)+5)).each { |i| input.insert(0,"\x00") }
    (0..(rand(5)+5)).each { |i| input.concat("\x00") }
    input = input.pkcs7_pad( length )
    blocks = build_keyblocks(input, length)
    
    cipher = OpenSSL::Cipher::AES.new(128, :ECB)
    cipher.encrypt
    cipher.padding = 0
    
    blocks.each { |block|
      block = cipher.update( block ) if rand(2)
      if !rand(2)
	      k = gen_rand_key	
	      block = cbc_encrypt( block, cipher, k, length )
      end
    }
    blocks.join
  end
end
