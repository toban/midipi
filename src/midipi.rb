require 'wiringpi'

require File.join(File.dirname(__FILE__), 'init.rb')
require File.join(File.dirname(__FILE__), 'midi_listener.rb') 
require File.join(File.dirname(__FILE__), 'adcv_listener.rb') 
require File.join(File.dirname(__FILE__), 'program.rb')
require File.join(File.dirname(__FILE__), '../util/parse_cmu.rb')
require File.join(File.dirname(__FILE__), '../util/word_db.rb')



class MidiPi

	attr_accessor :ser, :gpio,
	:pitch, :speed, :bend, :dict, :programs, :MIDIPI_PITCH_MESSAGE, :MIDIPI_SPEED_MESSAGE
	:dictionaries
	

	
	def initialize
		@pitch = 0
		
		@dictionaries = []
		@MIDIPI_SPEED_MESSAGE = 14
		@MIDIPI_PITCH_MESSAGE = 15
		
		@programs = Hash.new
		init_programs
		
		puts @programs
		
		@gpio = WiringPi::GPIO.new(WPI_MODE_GPIO)
		@ser = WiringPi::Serial.new('/dev/ttyAMA0', 9600)
		
		
	end
	
	def init_dictionary
		$log.info('loading dictionaries ...')
		@dictionaries << WordDB.new
		puts @dictionaries.inspect
	end
	
	# loads each program in program folder
	def init_programs
		$log.info("loading programs ...")
		Dir[File.join(File.dirname(__FILE__), "/programs/*.rb")].each {|file| 
		begin 
			require file 
		rescue LoadError, SyntaxError
			$log.info("failed to load program %s" % file.to_s) 
		end}
		
		$programs.each do |program|
			
			program.msg_map.keys.each do |key|
				
				if(program[key].nil?)
					
					if(@dictionaries.length == 0)
						init_dictionary
					end
					
					@dictionaries.each do |dict|
						if(dict.word_hash.has_key?(key))
							program[key] = dict.word_hash[key]
						end
					end
				end
			end
			@programs[program.program_id] = program
		end
		$log.info("loaded %s programs!" % programs.count)
	end
	
	def reset
		$log.info("speakjet reset")
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
		@ser.serialPuts('\A') # exit serial
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
	
        def stop_speaking
                set_serial_mode
                $log.info("stop. clear buffer ...")
                @ser.serialPuts('S')
                @ser.serialPuts('R')
                exit_serial_mode
        end
        
	# load note from program and say it
	def speech_program(program_id, note)
		
		word_note = @programs[program_id][note]
                stop_speaking()
		if !word_note.nil?
			$log.info("speaking: %s" % word_note.inspect)
			return speech(word_note.code)
		end
	end
	
	def speech(sentence)
		if !sentence.nil? 
			sentence.each do |i|
			@ser.serialPutchar(i)
			end
		end
	end


end






