require 'unimidi'

class MidiListener
	attr_accessor :input, :buffer_pointer, :midipi
	
	def initialize(midipi)
	
		@midipi = midipi
		@input = UniMIDI::Input.use(:first)
		@buffer_pointer = 0
		
	end
	
	def run
		$log.info("listening")
		buffer_length = 0
		while true
			#puts @input.buffer.inspect
			buffer_length = @input.buffer.length
			if buffer_length > @buffer_pointer
				msg = @input.buffer[@buffer_pointer]
				
				msg[:data].each do |command| 
					if command != 248
						puts "data: %s, timestamp: %s" % [msg[:data], msg[:timestamp]]
					end
					
					if command == 144
						midipi.speech_test
					end
				end
					
				@buffer_pointer = buffer_length
				
			end
		end
	end
end
