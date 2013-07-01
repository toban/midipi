#! /usr/bin/ruby

require 'rubygems' 
require 'daemons'
 
pwd = Dir.pwd 
Daemons.run_proc('main.rb', :dir => '/tmp/') do 
	Dir.chdir(pwd) 
	exec "ruby main.rb"
end
