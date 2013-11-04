#!/usr/bin/env ruby 

require "openssl" 
require "./modules/hex-b64.rb" 

class String
    include HexBase64
end

decipher = OpenSSL::Cipher::AES.new(128, :ECB)
decipher.decrypt
decipher.key = "YELLOW SUBMARINE"

clear = []

File.open("gist-prob7.gist", "r") do |infile|
    while line = infile.gets do
        line = line.strip.decode_base64
        clear.push( decipher.update(line) )
    end
end

puts clear
