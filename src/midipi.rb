#! /usr/bin/ruby
require 'wiringpi'
require './init.rb'
require './midi_listener.rb'



class MidiPi

	attr_accessor :ser, :pitch
	def initialize
		@ser = WiringPi::Serial.new('/dev/ttyAMA0', 9600)
		@pitch = 0
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
	
	def command_speed()
	
	end
	
	# midi from 0-127
	#speakjet from 0-255
	def command_pitch(midipitchMSB, midipitchLSB)

		value = (midipitchMSB << 7) + midipitchLSB
		
		if(value > 8192)
			normal = (value/16383.0)
			speakjetValue = 88 + (167.0**(normal*normal)) 
		else
			speakjetValue = (176 / 16383.0) * value
		end
		
		$log.debug("pitchbend: %s" % speakjetValue.round.to_i)
		
		@ser.serialPutchar(22)
		@ser.serialPutchar(speakjetValue.round.to_i)
	end
	
	def speech_code(code)
		@ser.serialPutchar(code)
	end
	
	def speech_touch
	
		[20, 96, 21, 114, 23, 5, 8, 191, 8, 134, 182].each do |i|
			@ser.serialPutchar(i)
		end
	end
	
	def speech_that
	
		[20, 96, 21, 114, 88, 23, 5, 169, 8, 132, 8, 191].each do |i|
			@ser.serialPutchar(i)
		end
	end

	def speech_ass
		
=begin
		[20, 100, 23, 5, 21, 114, 22, 88, 191, 21, 114, 22, 88, 131, 21, 114, 22, 88, 145, 21, 114, 22, 88, 131, 21, 114, 22, 88, 185, 21, 114, 22, 88, 129, 21, 114, 22, 88, 182, 14, 21, 114, 22, 88, 137, 21, 114, 22, 88, 141].each do |i|
=end		
		[20, 96, 21, 114, 88, 23, 5, 132, 132, 8, 187, 187, 187, 187, 187].each do |i|
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

threads = []
threads << Thread.new {MidiListener.new(midipi).run} 

midipi.set_serial_mode
midipi.reset


threads.each { |t| t.join }
midipi.release


