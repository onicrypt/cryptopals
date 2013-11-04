#!/usr/bin/env ruby

require "./modules/hex-b64.rb"
require "./modules/keygen.rb"
require "./modules/sc-xor.rb"
require "./modules/decrypt-xor.rb"

class String
  include HexBase64 
  include SingleCharXOR 
end

include KeyGen 
include Decrypt_XOR 

gistIn, gistOut, keys = {}, {}, {}
keyspace = Key.new.alpha_num
#Read in lines from file
File.open("gist-prob4.gist","r") do |infile|
  while (line = infile.gets)  
    gistIn[line.strip.decode_hex] = 0
  end
end

attempt = DecryptXOR.new("", keyspace)

gistIn.each_key {|encoded|
  attempt.new_digest(encoded)
  attempt.decrypt
  attempt.get_results
  gistIn[encoded] = attempt.max_score
  gistOut[attempt.clear_string] = attempt.max_score                             
  keys[attempt.clear_string] = attempt.found_key                             
}

maxScore = gistIn.values.max

gistIn.each_key {|line|
  if gistIn[line] == maxScore
    puts("Encrypted String: #{line.encode_hex}")
    gistIn.delete_if {|text, rank| rank == maxScore }
  end
}

gistOut.each {|line, score|
  if score == maxScore
    puts("Clear String: #{line}")
    puts("Decryption Key: #{keys[line]}")
    puts("Score: #{score}")
    gistOut.delete_if {|text, rank| rank == maxScore }
  end
}
