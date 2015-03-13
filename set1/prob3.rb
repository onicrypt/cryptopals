#!/usr/bin/env ruby
path = File.expand_path("../", __FILE__)
require path + "/../modules/sc-xor.rb"
require path + "/../modules/keygen.rb"
require path + "/../modules/hex-b64.rb"
require path + "/../modules/decrypt-xor.rb"

include Decrypt_XOR                                                             
include KeyGen                                                             

class String
  include HexBase64
  include SingleCharXOR
end

digest = "1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736"
digest = digest.decode_hex

##Build Array of all possible Hex values
keySpace = Key.new.alpha_num
##Build Hash for possible decoded strings
candidates = DecryptXOR.new(digest, keySpace) 
candidates.decrypt
candidates.get_results

puts("String: #{candidates.clear_string}")
puts("Decryption Key: #{candidates.found_key}")
puts("Score: #{candidates.max_score}")
