#!/usr/bin/env ruby 

require "openssl" 
require "./modules/hex-b64.rb" 
require "./modules/pkcs7.rb" 
require "./modules/build-keyblocks.rb" 
require "./modules/fixed-xor.rb" 
require "./modules/aes-cbc.rb" 

include BuildKeyblocks

class String
  include PKCS7 
  include HexBase64
  include FixedXOR
  include AES_CBC
end

cipher = OpenSSL::Cipher::AES.new(128, :ECB)
cipher.encrypt
cipher.padding = 0
cipher.key = "YELLOW SUBMARINE"
cipherIV = "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"

decipher = OpenSSL::Cipher::AES.new(128, :ECB)
decipher.decrypt
decipher.key = "YELLOW SUBMARINE"
decipher.padding = 0
decipherIV = cipherIV 

digest = []
File.open("gist-prob10.gist", "r") do |infile|
  while line = infile.gets do
    digest.push( line.strip.decode_base64 )
  end
end

#clearLine = digest.join
encrypted = digest.join
blockLength = 16

##Encryption
#encrypted = clearLine.cbc_encrypt(cipher, cipherIV, blockLength)
#puts("Encrypted text: #{encrypted}") 

##Decryption
decrypted = encrypted.cbc_decrypt(decipher, decipherIV, blockLength)
puts("Clear text: \n#{decrypted}") 
