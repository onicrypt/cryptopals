#!/usr/bin/env ruby

$LOAD_PATH << File.expand_path(File.dirname(__FILE__))

require "hex_b64"

class String
  include HexBase64
end

"efac43123".decode_hex
