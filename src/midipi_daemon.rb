#! /usr/bin/ruby

require 'rubygems' 
require 'daemons'
 
pwd = Dir.pwd 
Daemons.run_proc('main.rb', :dir => '/home/pi/midipi/src/', :log_output => '/tmp/midipi.log') do 
	Dir.chdir(pwd) 
	exec "ruby main.rb"
end
