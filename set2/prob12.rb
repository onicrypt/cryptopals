#!/usr/bin/env ruby
path = File.expand_path("../", __FILE__)

require "openssl" 
require "pry"
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

UNKNOWN = 
"""
Um9sbGluJyBpbiBteSA1LjAKV2l0aCBteSByYWctdG9wIGRvd24gc28gbXkg
aGFpciBjYW4gYmxvdwpUaGUgZ2lybGllcyBvbiBzdGFuZGJ5IHdhdmluZyBq
dXN0IHRvIHNheSBoaQpEaWQgeW91IHN0b3A/IE5vLCBJIGp1c3QgZHJvdmUg
YnkK
""".unpack("m*").first

def gen_rand_key
  key = ""
  16.times do key += rand(256).chr end
  key
end

KEY = gen_rand_key

def encryption_oracle_ecb(clear)
  cipher = OpenSSL::Cipher::AES.new(128, :ECB)
  cipher.encrypt
  cipher.key = KEY 
  digest = clear + UNKNOWN
  encrypted = cipher.update(digest) + cipher.final
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

def decrypt_ecb_byte_at_a_time
  block_length = detect_block_length
  mode = detection_oracle( encryption_oracle_ecb("N" * 48) )
  block_number = encryption_oracle_ecb.length / 16
  decrypt_blocks(block_number, block_length)  
end

def detect_block_length
  trial_byte = "N"
  block_length = 1
  found = false
  prev_res = ""
  # two consecutive trials will have identical first blocks
  # when correct block length is found
  while not found
    res = encryption_oracle_ecb(trial_byte * block_length)[0..15]
    if res == prev_res
      found = true
      block_length -= 1
    else 
      prev_res = res
      block_length += 1
    end
  end
  block_length
end

def build_dictionary(pad_length, found_bytes="")
  dictionary = {}
  padding_bytes = "N" * (pad_length - 1) + found_bytes
  total_length = pad_length + found_bytes.length
  0x7f.times do |c|
    res = encryption_oracle_ecb(padding_bytes + c.chr)
    dictionary[c.chr] = res.slice(0, total_length)
  end
  dictionary
end

def decrypt_block(block_number, block_length)
  decrypted = ""
  total_length = block_number * block_length
  total_length.times do |i|
    pad_length = total_length - i
    reference_dictionary = build_dictionary(pad_length, decrypted)
    byte_short_length = (total_length) - (i + 1)
    byte_short = "N" * byte_short_length
    shorty = encryption_oracle_ecb(byte_short).slice(0, total_length)
    if reference_dictionary.values.include? shorty
      decrypted += reference_dictionary.key(shorty)
    end
  end
  decrypted
end
