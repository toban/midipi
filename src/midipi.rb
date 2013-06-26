#! /usr/bin/ruby
require 'wiringpi'
require './init.rb'
require './midi_listener.rb'
require './program.rb'



class MidiPi

	attr_accessor :ser, :pitch, :speed, :bend, :dict, :programs
	
	def initialize
		#@ser = WiringPi::Serial.new('/dev/ttyAMA0', 9600)
		@pitch = 0
		
		@dict = {
		"a" => [154, 128],
		"stay" => [187, 191,154, 7, 128],
		"while" => [185, 155, 8, 145],
		"forever" => [186, 153, 130, 166, 7, 151],
		"touch" => [20,8, 191, 8, 134, 182],
		"that" => [20, 96, 88, 169, 8, 132, 8, 191],
		"ass" => [20, 96, 88, 132, 132, 8, 187, 187]
		}
		
		@programs = Hash.new
		init_programs
		
	end
	
	def init_programs
		$log.info("loading programs ...")
		Dir["./programs/*.rb"].each {|file| require file }
		
		$programs.each do |program| 
			@programs[program.program_id] = program
		end
		$log.info("loaded %s programs!" % programs.count)
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
	
	def command_bend(value)
		speakjetValue = ((15.0/127.0) * value).round.to_i
		$log.debug("bend: %s" % speakjetValue)
		@bend = speakjetValue
		@ser.serialPutchar(23)
		@ser.serialPutchar(@bend)
	end
	
	def command_speed(value)
		$log.debug("speed: %s" % value)
		@speed = value
		@ser.serialPutchar(21)
		@ser.serialPutchar(@speed)
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
		@pitch = speakjetValue.round.to_i
		
		@ser.serialPutchar(22)
		@ser.serialPutchar(@pitch)
	end
	
	def speech_code(code)
		@ser.serialPutchar(code)
	end
	
	def speech(word)
		
		sentence = nil
		
		sentence = @dict[word]
		
		if !sentence.nil? 
			sentence.each do |i|
			@ser.serialPutchar(i)
			end
		end
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


