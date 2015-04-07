#!/usr/bin/env ruby

$LOAD_PATH << File.expand_path(File.dirname(__FILE__))

require "openssl" 
require "pry"
require "./../init"
require "modules/aes-extend" 

include AES_EXTENDS
