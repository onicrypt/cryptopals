#!/usr/bin/env ruby
path = File.expand_path("../", __FILE__)
require path + "/../modules/hex-b64.rb"

class String
  include HexBase64
end

hexDigest="49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d"                                                    
base64Digest="SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t"
base64 = hexDigest.hex_to_base64
hex = base64.base64_to_hex

puts("Base 64: ", base64, "\n")
puts("Hex: ", hex, "\n")
puts("Now back to Vanilla Ice: ", base64.decode_base64, "\n") 
raise "You're doin' it wrong" unless base64 === base64Digest and hex === hexDigest
