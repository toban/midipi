#! /usr/bin/ruby
require 'rubygems' 
require 'net/ssh' 
require 'net/scp'  
HOST = '192.168.1.8' 
USER = 'pi' 
PASS = 'raspberry' 

remote_path = "/home/pi/midipi"
exec_path = "/src/midipi_daemon.rb restart"
puts "Connecting ..."

Net::SSH.start( HOST, USER, :password => PASS ) do|ssh|
	puts "Connected ..."
	result = ssh.exec!('cd /home/pi/midipi/src/; sudo ./midipi_daemon.rb stop')
	puts result 
	result = ssh.exec!('rm -rf ' + remote_path) 
	puts result 
	puts "Delete old files ..."
	puts "Upload started ..."
	Net::SCP.upload!(HOST, USER, "../../midipi", remote_path, :ssh => { :password => PASS}, :recursive=> true, :verbose=>true)
	puts "Upload finished ..."
	##result = ssh.exec!('cd /home/pi/midipi/src/; sudo ./midipi_daemon.rb start')
	##result = ssh.exec!('')
	#puts result 
end


#exec( "ls ../../midipi" )
