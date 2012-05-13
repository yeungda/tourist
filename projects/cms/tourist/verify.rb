#!/usr/bin/env ruby
require File.dirname(__FILE__) + "/../../../lib/verify.rb"
Dir[File.dirname(__FILE__) + "/expectations/*.rb"].each {|file| require file }
verify
