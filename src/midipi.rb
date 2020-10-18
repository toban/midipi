require 'wiringpi2'

require File.join(File.dirname(__FILE__), 'init.rb')
require File.join(File.dirname(__FILE__), 'midi_listener.rb') 
require File.join(File.dirname(__FILE__), 'adcv_listener.rb') 
require File.join(File.dirname(__FILE__), 'program.rb')
require File.join(File.dirname(__FILE__), 'rotary_encoder.rb')
require File.join(File.dirname(__FILE__), 'gui_manager.rb')
require File.join(File.dirname(__FILE__), '../util/parse_cmu.rb')
require File.join(File.dirname(__FILE__), '../util/word_db.rb')

class MidiPi

	attr_accessor :ser, :gpio, :encoder,
	:pitch, :midi_listener, :speed, :play_mode, :bend, :dict, :programs, :MIDIPI_PITCH_MESSAGE, :MIDIPI_SPEED_MESSAGE
	:dictionaries

	def set_mode(mode)
		@play_mode = mode
		case mode
			when MIDIPI_MODE::SYNTHESIZER_MODE
				serial_puts('\0');
				set_osc_vol(1, 200)
		end
	end

	def poll()
		@gui.poll
		#$log.info("midipi: poll: %s" % @play_mode)

		case @play_mode
			when MIDIPI_MODE::PLAY_MODE
				midi_listener.poll(@play_mode)
			when MIDIPI_MODE::SYNTHESIZER_MODE
				midi_listener.poll(@play_mode)
			when MIDIPI_MODE::TRIGGER_MODE
		end
	end

	def dictionaries
		return @dictionaries
	end

	def initialize()
		@pitch = 0

		
		@dictionaries = []
		@MIDIPI_SPEED_MESSAGE = 14
		@MIDIPI_PITCH_MESSAGE = 15
		
		@programs = Hash.new
		init_programs
		
		#puts @programs
		
		@gpio = WiringPi::GPIO.new#WPI_MODE_GPIO)
		@ser = WiringPi::Serial.new('/dev/ttyAMA0', 9600)
		@midi_listener = MidiListener.new(self)

		@encoder = RotaryEncoder.new(4,5, @gpio)
		@gui = GuiManager.new(@encoder, self)
	end
	
	def init_dictionary
		$log.info('loading dictionaries ...')
		@dictionaries << WordDB.new

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
		@ser.serial_puts('W')
	end
	
	def lerp(a, b, f) 
	    return (a * (1.0 - f)) + (b * f)
	end

	def release
		exit_serial_mode
		@ser.serialClose
	end
	
	def set_serial_mode
		$log.info("set to serial")
		@ser.serial_puts('\0') # enable serial
		#@ser.serial_puts('V') # feedback
	end
	
	def exit_serial_mode
		$log.info("exit serial")
		@ser.serial_puts('\A') # exit serial
	end
	
	def serial_puts(msg)
		@ser.serial_puts(msg)
	end
	#0 is env
	#1-5 is audio oscillators
	def set_osc_freq(osc, value)
		@ser.serial_puts(osc.to_s+'J')
		@ser.serial_puts(value.to_s+'N')
	end

	def set_master_vol(value)
		@ser.serial_puts('7J')
		@ser.serial_puts(value.to_s+'N')
	end

	def set_osc_distortion(value)

		if value < 0 
			value = 0
		else value > 255
			value = 255
		end
		@ser.serial_puts('6J')
		@ser.serial_puts(value.to_s+'N')
	end

	'''
	00 = Saw Wave
	01 = Sine Wave
	10 = Triangle Wave
	11 = Square Wave
	
	ENV_SAW = 0
	ENV_SIN = 1
	ENV_TRI = 2
	ENV_SQR = 4
	'''
	def set_envelope_control(value)
		if value < 0 
			value = 0
		else value > 255
			value = 255
		end

		serial_puts('8J')
		serial_puts(value.to_s+'N')
	end

	def set_osc_vol(osc, value)

		@ser.serial_puts((osc+10).to_s+'J')
		@ser.serial_puts(value.to_s+'N')
	end

	def command_bend(value)
		speakjetValue = ((15.0/127.0) * value).round.to_i
		$log.debug("bend: %s" % speakjetValue)
		@bend = speakjetValue
		@ser.serial_put_char(23)
		@ser.serial_put_char(@bend)
	end
	
	def command_speed(value)
		$log.debug("speed: %s" % value)
		@speed = value
		@ser.serial_put_char(21)
		@ser.serial_put_char(@speed)
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
		
		@ser.serial_put_char(22)
		@ser.serial_put_char(@pitch)
	end
	
	def speech_code(code)
		@ser.serial_put_char(code)
	end
	
        def stop_speaking
                set_serial_mode
                $log.info("stop. clear buffer ...")
                @ser.serial_puts('S')
                @ser.serial_puts('R')
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
			@ser.serial_put_char(i)
			end
		end
	end


end
