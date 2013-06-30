#! /usr/bin/ruby

require 'rubygems' 
require 'daemons'
 
pwd = Dir.pwd 
Daemons.run_proc('main.rb') do 
	Dir.chdir(pwd) 
	exec "ruby main.rb"
end
