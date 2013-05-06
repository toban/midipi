require 'unimidi'

class MidiListener
	attr_accessor :input, :buffer_pointer, :midipi, :msg_mean_time
	
	def initialize(midipi)
	
		@midipi = midipi
		@input = UniMIDI::Input.use(:first)
		@buffer_pointer = 0
		
	end
	
	def run
		$log.info("listening")
		buffer_length = 0
		last_msg_time = Time.now
		current_msg_time = Time.now
		while true
		
			buffer_length = @input.buffer.length
			
			while buffer_length > @buffer_pointer
			
				msg = @input.buffer[@buffer_pointer]
				
				current_msg_time = Time.now
				
				
				for i in 0..msg[:data].length-1
					
		 			command = msg[:data][i]
		 			
					if command != 248
						puts "data: %s, timestamp: %s" % [msg[:data], msg[:timestamp]]
					else
						#puts msg[:timestamp]
					end
					
					if command == 144
						
						if(i+1 < msg[:data].length)
							i+=1
							note = msg[:data][i]
							
							case note
							
							when 6
								midipi.speech_touch
							when 7 
								midipi.speech_that
							when 9
								midipi.speech_ass	 
							end
							
							#midipi.speech_code(128+note)
						end
				
						#midipi.speech_test
					end
				end
				
				
				
				last_msg_time = current_msg_time
				@buffer_pointer+=1
				
			end
			sleep(0.009)
			
		end
	end
end
