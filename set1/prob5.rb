#!/usr/bin/env ruby
path = File.expand_path("../", __FILE__)

require path + "/../modules/repeating-xor.rb"
require path + "/../modules/hex-b64.rb"

class String
  include HexBase64 
  include RepeatingXOR
end

clearKey = "ICE"
clearString = "Burning 'em, if you ain't quick and nimble\nI go crazy when I hear a cymbal"

#clearKey = "AesopRock"
#clearString = "I'll take my seat atop the Brooklyn Bridge\nWith a Coke and a bag of chips\nTo watch a thousand lemmings plummet just because\nThe first one slipped"

expectedString = "0b3637272a2b2e63622c2e69692a23693a2a3c6324202d623d63343c2a26226324272765272a282b2f20430a652e2c652a3124333a653e2b2027630c692b20283165286326302e27282f"

encryptedString = clearString.repeating_xor(clearKey).encode_hex

print("Clear String: \n", clearString, "\n")
print("Encrypted String: \n", encryptedString, "\n")

raise "You're doin' it wrong" unless encryptedString === expectedString
