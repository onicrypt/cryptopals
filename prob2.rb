#!/usr/bin/env ruby
require "./modules/hex-b64.rb"
require "./modules/fixed-xor.rb"

class String
  include HexBase64
  include FixedXOR
end

buffOne     = "1c0111001f010100061a024b53535009181c".decode_hex
buffTwo     = "686974207468652062756c6c277320657965".decode_hex
expectedXOR = "746865206b696420646f6e277420706c6179"
resXOR      = buffOne.fixed_xor(buffTwo)
resXOR      = resXOR.encode_hex

puts("BuffOne: ", buffOne.encode_hex, "\n")
puts("BuffTwo: ", buffTwo.encode_hex, "\n")
puts("Resulting XOR: ", resXOR, "\n")
raise "You're doin it wrong" unless resXOR === expectedXOR  
