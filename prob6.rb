#!/usr/bin/env ruby

require "bigdecimal"
require "./modules/keygen.rb"
require "./modules/hex-b64.rb"
require "./modules/sc-xor.rb"
require "./modules/decrypt-xor.rb"
require "./modules/repeating-xor.rb"
require "./modules/hamming-distance.rb"

class String                                                                   
  include HexBase64
  include SingleCharXOR
  include RepeatingXOR
  include HammingDistance
end

include KeyGen
include Decrypt_XOR

cipher = "Jk8DCkkcC3hFMQIEC0EbAVIqCFZBO1IdBgZUVA4QTgUWSR4QJwwRTWM="
cipher = cipher.decode_base64
testCipher = "The sight which met his eyes confirmed his worst fears."
testCipher = testCipher.repeating_xor("4b0Ntk")

#Find keysize chunks of cipher with lowest hamming distance
keysize = 2
scores = {}
while (keysize * 4) <= cipher.bytesize do
  #Break cipher into keysize chunks of bytes
  chunk1 = cipher.byteslice(0..(keysize - 1))
  chunk2 = cipher.byteslice((keysize)..((keysize * 2) - 1))
  chunk3 = cipher.byteslice((keysize * 2)..((keysize * 3) - 1))
  chunk4 = cipher.byteslice((keysize * 3)..((keysize * 4) - 1))
 
  #Calculate and normalize hamming distance
  ham1 = chunk1.hamming_distance(chunk2) / Float(keysize)
  ham2 = chunk2.hamming_distance(chunk3) / Float(keysize)
  ham3 = chunk3.hamming_distance(chunk4) / Float(keysize)
  sum = ham1 + ham2 + ham3
  avg = sum / 3
  scores[keysize] = (avg * 100).ceil #Eliminate decimal issue w/o BigDecimal
  keysize += 1
end

keysize = [] 

for num in (0..2)
  min = scores.values.min
  scores.each {|length,score|
    if score == min
      keysize.push(length)
      scores.delete(length)
    end
  }
end
#puts("Scores: #{scores}")
#puts("Keysizes: #{keysize}")

#Break cipher text into key-size blocks
def build_keyblocks(cipher, length)
  index = 0
  keyblocks = []
  while ( (index * length) + length - 1) < cipher.bytesize do
    block = cipher.byteslice(index * length, length)
    keyblocks.push(block) unless block.eql?nil
    index += 1
  end
  keyblocks
end

#Repeat steps E-H for each selected keysize
rounds = keysize.length
for round in (1..rounds) do
  #Build keyBlocks of keysize length from the cipher
  keyBlocks = build_keyblocks(cipher, keysize[round-1])
  
  #Each member(n) of byteBlocks consists of 
  #the nth byte from each block in keyBlocks
  byteBlocks = {}
  keyBlocks.each {|block|
    endByte = block.bytesize - 1 
    
    for byte in (0..endByte)
      byteString = byteBlocks[byte].to_s
      addByte = block.slice(byte)
      byteBlocks[byte] = byteString.concat( addByte )
    end
  }
  
  #Solve each transposed block as single-character XOR
  key = Key.new.alpha_num
  special = Key.new.special
  special.each {|sp| key.push(sp) }
   
  repKey = "" 
  scores = []
  byteBlocks.each_value{|transposed|
      candidates = DecryptXOR.new(transposed, key)
      candidates.decrypt
      candidates.get_results
  
      repKey.concat(candidates.found_key)
      scores.push(candidates.max_score)
  }
  
  clearString = cipher.repeating_xor(repKey)
  puts("")
  puts("*____________*")
  puts("*  Round #{round}   *")
  puts("*____________*")
  
  #puts("Key Blocks: #{keyBlocks}")
  puts("Byte Blocks: #{byteBlocks}")

  puts("Keysize #{keysize[round-1]}")
  puts("Repeating Key: #{repKey}")
  puts("Clear String: #{clearString.strip}")
  puts("Scores: #{scores.join(' ')}")
end
