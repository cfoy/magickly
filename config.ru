require 'rubygems'
require 'bundler'
require 'dotenv'

Bundler.require

Dotenv.load

require File.join(File.dirname(__FILE__), 'lib', 'magickly')

run Magickly::App
