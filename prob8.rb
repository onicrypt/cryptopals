#!/usr/bin/env ruby 

require "./modules/hex-b64.rb" 
require "./modules/build-keyblocks.rb"

class String
    include HexBase64
end

include BuildKeyblocks

collection = []
keysize = 16

File.open("gist-prob8.gist", "r") do |infile|
    while line = infile.gets do
        #Decode each line
        line = line.strip.decode_hex
        #Break lines into keysize blocks
        collection.push( build_keyblocks(line, keysize) )
    end
end

for test in collection do
    found = false
    #Test each block of the current line (test)
    test.each_index {|index|
        innerIndex = index + 1 
        #"innerIndex" blocks don't need to include blocks up to "index"
        #since each "index" block is tested against all blocks
        while innerIndex < test.length do
            if test[index] == test[innerIndex]
                puts("On line: #{test.join.encode_hex}")
                puts("Found matching blocks #{index} and #{innerIndex}")
                found = true
                break
            end
            innerIndex += 1
        end
        break if found
    }
    break if found
end

#puts("Key Blocks: #{clear}")
#clear.each {|line| puts line if line.ascii_only? }
