#!/usr/bin/env ruby
path = File.expand_path("../", __FILE__)

require "openssl" 
require path + "/../modules/hex-b64.rb"
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

KEY = gen_rand_key
UNKNOWN = 
"""
Um9sbGluJyBpbiBteSA1LjAKV2l0aCBteSByYWctdG9wIGRvd24gc28gbXkg
aGFpciBjYW4gYmxvdwpUaGUgZ2lybGllcyBvbiBzdGFuZGJ5IHdhdmluZyBq
dXN0IHRvIHNheSBoaQpEaWQgeW91IHN0b3A/IE5vLCBJIGp1c3QgZHJvdmUg
YnkK
"""

def gen_rand_key
  key = ""
  16.times do key += rand(256).chr end
  key
end

def encryption_oracle_ecb(clear)
  cipher = OpenSSL::Cipher::AES.new(128, :ECB)
  cipher.encrypt
  cipher.key = KEY 
  block_length = 16
  digest = clear + UNKNOWN 
  encrypted = cipher.update(digest) + cipher.final
end

