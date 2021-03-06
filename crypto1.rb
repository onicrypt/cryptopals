#!/usr/bin/env ruby

#//--------------------------------------------------------------------------\\#
#|  Problem 1                                                                 |#
#\\--------------------------------------------------------------------------//#
require "./modules/hex-b64.rb"

class String
    include HexBase64
end

#print("\n#|-----------|#")
#print("\n#| Problem 1 |#")
#print("\n#|-----------|#\n\n")
#
hexDigest="49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d"
base64Digest="SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t"
base64 = hexDigest.hex_to_base64
hex = base64.base64_to_hex

puts("Base 64: ", base64, "\n")
puts("Hex: ", hex, "\n")
puts("Now back to Vanilla Ice: ", base64.decode_base64, "\n") 
raise "You're doin' it wrong" unless base64 === base64Digest and hex === hexDigest
#
##//--------------------------------------------------------------------------\\#
##|  Problem 2                                                                 |#
##\\--------------------------------------------------------------------------//#
class String
  def fixed_xor(other)
    raise "Buffer lengths not equal" unless self.bytesize == other.bytesize
    #Unpack buffers into byte array and byte enum
    b1Arr = self.bytes       
    b2Enum = other.each_byte
    #XOR each Array element w/ each Enum element
    b1Arr.map! {|b| b ^ b2Enum.next}
  end
end

print("\n#|-----------|#")
print("\n#| Problem 2 |#")
print("\n#|-----------|#\n\n")

buffOne     = "1c0111001f010100061a024b53535009181c".decode_hex
buffTwo     = "686974207468652062756c6c277320657965".decode_hex
expectedXOR = "746865206b696420646f6e277420706c6179"
resXOR      = buffOne.fixed_xor(buffTwo).pack('C*').encode_hex

puts("BuffOne: ", buffOne.encode_hex, "\n")
puts("BuffTwo: ", buffTwo.encode_hex, "\n")
puts("Resulting XOR: ", resXOR, "\n")
raise "You're doin it wrong" unless resXOR === expectedXOR

##//--------------------------------------------------------------------------\\#
##|  Problem 3                                                                 |#
##\\--------------------------------------------------------------------------//#
class String
  def sc_xor(key)
    stringBytes = self.bytes
    key = key.bytes
    stringBytes.map! {|item| item ^ key.first}
    stringBytes.pack('C*')
  end
end

class Key < Array
  attr_reader :key
  def initialize
    @key = []
  end

  def low_alpha
    if @key.empty? 
      @key = ('a'..'z').to_a 
    else 
      ('a'..'z').each{|a| @key.push(a)}
      @key
    end
  end

  def high_alpha
    if @key.empty? 
      @key = ('A'..'Z').to_a 
    else 
      ('A'..'Z').each{|a| @key.push(a)}
      @key
    end
  end

  def alpha_num
    self.low_alpha
    self.high_alpha 
    ('0'..'9').each{|n| @key.push(n)}
    @key
  end

  def special
    sp = ['!','@','#','$','%','^','&','*','(',')',
          '{','|','\\','"',':',';','/','.',',','<',
          '>','?','`','~','-','=','_','+'] 
    if @key.empty? 
      @key = sp 
    else 
      sp.each {|s| @key.push(s)} 
      @key
    end 
  end
end

#class DecryptXOR < Hash
#  attr_accessor :digest
#  attr_reader :key_vals, :clear_string, :found_key, :found_index, :max_score
#  def initialize(digest, keyVals)
#    @digest = digest
#    @key_vals = keyVals
#  end
#
#  def new_digest(newDigest)
#    @digest = newDigest
#    self.delete_if{|key, value| key === key}
#  end
#  
#  def decrypt
#    #XOR each Hex value with hexDigest
#    #Give each a default score of zero
#    @key_vals.each {|k| self[@digest.sc_xor(k)] = 0}
#
#    char_count = Hash.new
#    
#    self.each {|string, score| 
#      #skip strings containing non-ASCII chars
#      next unless string.ascii_only? 
#  
#      #Switch to lower case to regularize comparisons
#      s = string.downcase
#      size = s.size
#
#      #Store letter count for each letter in string  
#      for letter in 'a'..'z' do
#        char_count[letter] = s.count(letter)
#      end
#
#      #Add 1 to score if character frequencies match expected values
#      if ( char_count['e'] / Float(size) ) >= 0.12 then score += 1 end
#      if ( char_count['t'] / Float(size) ) >= 0.09 then score += 1 end
#      if ( char_count['a'] / Float(size) ) >= 0.08 then score += 1 end
#      if ( char_count['o'] / Float(size) ) >= 0.07 then score += 1 end
#      if ( char_count['i'] / Float(size) ) >= 0.06 then score += 1 end
#      if ( char_count['n'] / Float(size) ) >= 0.06 then score += 1 end
#      if ( char_count['s'] / Float(size) ) >= 0.06 then score += 1 end
#      if ( char_count['h'] / Float(size) ) >= 0.06 then score += 1 end
#      if ( char_count['r'] / Float(size) ) >= 0.05 then score += 1 end
#      if ( char_count['d'] / Float(size) ) >= 0.04 then score += 1 end
#      if ( char_count['l'] / Float(size) ) >= 0.04 then score += 1 end
#      if ( char_count['c'] / Float(size) ) >= 0.02 then score += 1 end
#      if ( char_count['u'] / Float(size) ) >= 0.02 then score += 1 end
#      if ( char_count['m'] / Float(size) ) >= 0.02 then score += 1 end
#      if ( char_count['w'] / Float(size) ) >= 0.02 then score += 1 end
#      if ( char_count['f'] / Float(size) ) >= 0.02 then score += 1 end
#      if ( char_count['g'] / Float(size) ) >= 0.02 then score += 1 end
#      if ( char_count['y'] / Float(size) ) >= 0.01 then score += 1 end
#      if ( char_count['p'] / Float(size) ) >= 0.01 then score += 1 end
#      if ( char_count['b'] / Float(size) ) >= 0.01 then score += 1 end
#      if ( char_count['v'] / Float(size) ) <= 0.01 then score += 1 end
#      if ( char_count['k'] / Float(size) ) <= 0.01 then score += 1 end
#      if ( char_count['j'] / Float(size) ) <= 0.01 then score += 1 end
#      if ( char_count['x'] / Float(size) ) <= 0.01 then score += 1 end
#      if ( char_count['q'] / Float(size) ) <= 0.01 then score += 1 end
#      if ( char_count['z'] / Float(size) ) <= 0.01 then score += 1 end
#      #check for conditions less likely in an English string of text
#      if ( string.match(/[a-z][A-Z]{2,}/) ) then score -= 1 end  
#      #if ( string.match(/[0-9]{2,}[A-Z]{2,}/) ) then score -= 1 end  
#      #if ( string.match(/[\W]{2,}/) ) then score -= 1 end  
#
#      self[string] = score
#    }
#  end
#
#  def get_results
#    #Convert Hash to Array
#    #Makes finding correct key index easier
#    candidates_array = self.to_a
#    @max_score = self.values.max
#
#    candidates_array.each_with_index {|string, index|
#      if string[1] == @max_score
#        @found_index = index 
#        @clear_string = string[0]
#      end 
#    }
#
#    (@found_key = @key_vals[@found_index]) unless @found_index.nil?
#  end
#end
#
#print("\n#|-----------|#")
#print("\n#| Problem 3 |#")
#print("\n#|-----------|#\n\n")
#
require "./modules/decrypt-xor.rb"
include Decrypt_XOR

digest = "1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736"
digest = digest.decode_hex

##Build Array of all possible Hex values
keySpace = Key.new.alpha_num
##Build Hash for possible decoded strings
candidates = DecryptXOR.new(digest, keySpace) 
candidates.decrypt
candidates.get_results

print("String: #{candidates.clear_string} \n")
print("Score: #{candidates.max_score} \n")
print("Decryption Key: #{candidates.found_key} \n")
#
##//--------------------------------------------------------------------------\\#
##|  Problem 4                                                                 |#
##\\--------------------------------------------------------------------------//#
#
#print("\n#|-----------|#")
#print("\n#| Problem 4 |#")
#print("\n#|-----------|#\n\n")
#
gistIn = Hash.new
gistOut = Hash.new

#Read in lines from file
File.open("gist-prob4.txt","r") do |infile|
  while (line = infile.gets)  
    gistIn[line.strip.decode_hex] = 0
  end
end

attempt = DecryptXOR.new("", keySpace)

gistIn.each_key {|encoded|
  attempt.new_digest(encoded)
  attempt.decrypt
  attempt.get_results
  gistIn[encoded] = attempt.max_score
  gistOut[attempt.clear_string] = attempt.max_score
}

gistIn.each_key{|line|
  if gistIn[line] == gistOut.values.max
    print("\nEncrypted String: ", line.encode_hex, "\n")
  end
}

gistOut.each {|line, score|
  if gistOut[line] == gistOut.values.max
    print("String: ", line)
    print("Score: ", score, "\n")
  end
}

#//--------------------------------------------------------------------------\\#
#|  Problem 5                                                                 |#
#\\--------------------------------------------------------------------------//#
class String
  def repeating_xor(key)
    bytes = self.bytes
    key = key.bytes
    bytes.each_with_index {|item, index| 
      key_index = index % key.size
      bytes[index] = item ^ key[key_index]
    }
    bytes.pack('C*')
  end
end
#
#print("\n#|-----------|#")
#print("\n#| Problem 5 |#")
#print("\n#|-----------|#\n\n")

clearKey = "ICE"
clearString = "Burning 'em, if you ain't quick and nimble\nI go crazy when I hear a cymbal"

#clearKey = "AesopRock"
#clearString = "I'll take my seat atop the Brooklyn Bridge\nWith a Coke and a bag of chips\nTo watch a thousand lemmings plummet just because\nThe first one slipped"

expectedString = "0b3637272a2b2e63622c2e69692a23693a2a3c6324202d623d63343c2a26226324272765272a282b2f20430a652e2c652a3124333a653e2b2027630c692b20283165286326302e27282f"

encryptedString = clearString.repeating_xor(clearKey).encode_hex

print("Clear String: \n", clearString, "\n")
print("Encrypted String: \n", encryptedString, "\n")

raise "You're doin' it wrong" unless encryptedString === expectedString
