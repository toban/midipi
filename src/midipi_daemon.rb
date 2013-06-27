#! /usr/bin/ruby

require 'rubygems' 
require 'daemons'
 
pwd = Dir.pwd 
Daemons.run_proc('midipi.rb') do 
	Dir.chdir(pwd) 
	exec "ruby midipi.rb"
end
