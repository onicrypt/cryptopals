#!/usr/bin/env ruby 

class String
  def convert_base(from, to)
    self.to_i(from).to_s(to)
  end
end

plainText = ""

if ARGV.count < 1
  plainText = "YELLOW SUBMARINE"
elsif ARGV.count == 1
  plainText = ARGV.first.to_s.dup
else
  puts("Usage: ./prob9.rb \"plain-text\"")
  Kernel.exit
  exit
end

blockLength = 32 
ptLength = plainText.length

puts("Plain text:\n  #{plainText}")
padLen    = 0
remainder = ptLength % blockLength
padLen    = blockLength - remainder unless ( remainder == 0 )
padStr    = padLen.to_s.convert_base(10, 16)
padStr    = padLen < 16 ? padStr.prepend("\\x0") : padStr.prepend("\\x")
for i in 0...padLength do
  plainText << padStr
end

puts("Padded Text:\n  #{plainText}")
