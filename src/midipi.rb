#! /usr/bin/ruby
require 'wiringpi'
require './init.rb'



class MidiPi

	attr_accessor :ser
	def initialize
		@ser = WiringPi::Serial.new('/dev/ttyAMA0', 9600)
	end
	
	def reset
		@ser.serialPuts('W')
	end
	
	def release
		exit_serial_mode
		@ser.serialClose
	end
	
	def set_serial_mode
		$log.info("set to serial")
		@ser.serialPuts('\0') # enable serial
		#@ser.serialPuts('V') # feedback
	end
	
	def exit_serial_mode
		$log.info("exit serial")
		@ser.serialPuts('A') # exit serial
	end
	
	def speech_test

		[20, 100, 23, 5, 21, 114, 22, 88, 191, 21, 114, 22, 88, 131, 21, 114, 22, 88, 145, 21, 114, 22, 88, 131, 21, 114, 22, 88, 185, 21, 114, 22, 88, 129, 21, 114, 22, 88, 182, 14, 21, 114, 22, 88, 137, 21, 114, 22, 88, 141].each do |i|
			@ser.serialPutchar(i)
		end
		#@ser.serialPuts('T')
	end 
	
	
	def osctest
		set_serial_mode
		$log.info("osctest")

		# envelope freq
		#@ser.serialPuts('0J')
		#@ser.serialPuts('10N') # 1100010		
		
		osctest_freq
		
		# envelope control
		@ser.serialPuts('8J')
		@ser.serialPuts('98N') # 1100010
		
		@ser.serialPuts('1J')
		@ser.serialPuts('200N')
		@ser.serialPuts('11J')
		@ser.serialPuts('16N')

	end
	
	def osctest_freq
		@ser.serialPuts('0J')
		
		@ser.serialPuts('%sN' % rand(255)) # 1100010	
	end 

end

midipi = MidiPi.new
midipi.set_serial_mode
midipi.reset
#sleep(1)
midipi.speech_test
#sleep(2)
midipi.release


