#!/usr/bin/env ruby
require 'tourist'
Dir["./expectations/*.rb"].each {|file| require file }
verify
