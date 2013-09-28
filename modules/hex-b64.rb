#!/usr/bin/env ruby
module HexBase64
    def decode_hex
        return [self].pack("H*")
    end

    def decode_base64
        return self.unpack("m0").first
    end

    def encode_hex
        return self.unpack("H*").first
    end

    def encode_base64
        return [self].pack("m0")
    end

    def hex_to_base64
        return self.decode_hex.encode_base64 
    end

    def base64_to_hex
        return self.decode_base64.encode_hex
    end
end
