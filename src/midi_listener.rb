require 'unimidi'

class MidiListener
	attr_accessor :input, :buffer_pointer
	
	def initialize
		
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
				if msg[:data] != [248]
					puts "data: %s, timestamp: %s" % [msg[:data], msg[:timestamp]]
				end
				@buffer_pointer = buffer_length
				
			end
		end
	end
end
