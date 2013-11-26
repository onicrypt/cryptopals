require "openssl"
require "hex-b64.rb"
require "pkcs7.rb"
require "build-keyblocks.rb"
require "fixed-xor.rb"
require "aes-cbc.rb"

include BuildKeyBlocks

class String
  include PKCS7
  include HexBase64
  include FixedXOR
  include AES_CBC
end

module AES_EXTENDS
  def random_key
    key = String.new("")
    pool = ("\x00".."\x7f").to_a
    (0...16).each { |i| key.concat( pool.at( rand(pool.length) ) ) }
    key
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
	k = random_key()	
	block = block.cbc_encrypt( cipher, k, length )
      end
    }
    blocks.join
  end
end
