#!/usr/bin/env ruby

$LOAD_PATH << File.expand_path(File.dirname(__FILE__))

require "openssl" 
require "pry"
require "./../init"
require "modules/aes-extend" 

include AES_EXTENDS

def parse_kv(input)
  kv_pair = input.split("&")
  output = {}
  kv_pair.each do |pair|
    kv = pair.split("=")
    output[kv.first.to_sym] = kv.last
  end
  output
end

def encode_profile(profile)
  "email=#{profile['email']}&uid=#{profile['uid']}&role=#{profile['role']}"
end

def profile_for(email)
  email.gsub("/[=&]*/", "")
  role = "user"
  # Debug line to generate valid admin profile
  role = "admin" if email.include? "admin_test"
  profile = {'email' => email, 'uid' => rand(10..99), 'role' => role}
  encode_profile(profile)
end

def get_email
  print "Enter an email: "
  email = gets.chomp
  profile_for(email)
end

KEY = gen_rand_key

def encrypt_profile
  profile = get_email
  ecb_encrypt(profile, KEY)
end

def decrypt_profile(profile)
  parse_kv ecb_decrypt(profile, KEY)
end

def attacker_swap(admin_cipher, attacker_cipher)
  attacker_cipher[-16..-1] = admin_cipher[-16..-1]
  attacker_cipher
end

crypted_admin = ecb_encrypt(profile_for("admin_test@t.com"), KEY)
cipher_profile = encrypt_profile
attacker_admin = attacker_swap(crypted_admin, cipher_profile)
puts decrypt_profile(attacker_admin)
