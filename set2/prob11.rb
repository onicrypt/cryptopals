#!/usr/bin/env ruby
path = File.expand_path("../", __FILE__)

require "openssl" 
require path + "/../modules/hex-b64.rb" 
require path + "/../modules/pkcs7.rb" 
require path + "/../modules/build-keyblocks.rb" 
require path + "/../modules/fixed-xor.rb" 
require path + "/../modules/aes-cbc.rb" 

include BuildKeyblocks

class String
  include PKCS7 
  include HexBase64
  include FixedXOR
  include AES_CBC
end

def gen_rand_key
  key = ""
  16.times do key += rand(256).chr end
  key
end

def encryption_oracle(clear)
  cipher = OpenSSL::Cipher::AES.new(128, :ECB)
  cipher.encrypt
  cipher.key = gen_rand_key
  
  pad_length = rand(5..10)
  padding = "\x00" * pad_length
  block_length = 16
  digest = padding + clear + padding
  encrypted = ""  
  if rand(2) == 1
    iv = gen_rand_key 
    encrypted = digest.cbc_encrypt(cipher, iv, block_length)
  else
    encrypted = cipher.update(digest) + cipher.final
  end
  encrypted
end

def detection_oracle(cipher_text)
  """Checks if same cipher block occurs twice in cipher text"""
  t1 = cipher_text.slice(16, 16)
  t2 = cipher_text.slice(32, 16)
  mode = ""
  if t1 == t2
    mode = "ecb"
  else
    mode = "cbc"
  end
  mode
end

def output
  test = encryption_oracle("a" * 42)
  puts "Encryption mode: #{detection_oracle(test)}"
end

output
#binding.pry
