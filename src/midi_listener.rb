require 'unimidi'

class MidiListener
	attr_accessor :input, :buffer_pointer, :midipi, :msg_mean_time, :channels, :listening_channel, :cmd_i
	
	def initialize(midipi)
	
		@midipi = midipi
		@input = UniMIDI::Input.use(:first)
		@buffer_pointer = 0
		
		@channels = Array.new
		for i in 0..15
			@channels << MidiChannel.new(224+i,144+i, 128+i, 176+i)
		end
		
		@midichan = @channels[0]
		
		
	end
	
	def getNextCommand(msg)
		if(@cmd_i+1 < msg[:data].length)
			@cmd_i+=1
			command = msg[:data][@cmd_i]
			return command
		end
		return nil
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
				
				
				for @cmd_i in 0..msg[:data].length-1
					
		 			command = msg[:data][@cmd_i]
		 			
					if command != 248
						#puts "data: %s, timestamp: %s" % [msg[:data], msg[:timestamp]]
					else
						#puts msg[:timestamp]
					end
					
					if command == @midichan.pitchbend
						
						puts "data: %s, timestamp: %s" % [msg[:data], msg[:timestamp]]
						lsbvalue = getNextCommand(msg)
						msbvalue = getNextCommand(msg)
						midipi.command_pitch(msbvalue.nil? ? 0 : msbvalue, lsbvalue.nil? ? 0 : lsbvalue )
						next
						
					end
					
					if command == @midichan.control_change
						
						next
					end
					
					if command == @midichan.note_on
					
						note = nil
						note = getNextCommand(msg)
						
						if(!note.nil?)
							
							case note
							
							when 6
								puts "touch"
								midipi.speech_touch
							when 7 
								puts "that"
								midipi.speech_that
							when 9
								puts "ass"
								midipi.speech_ass	 
							end
							
							#midipi.speech_code(128+note)
						end
				
						next
					end
				end
				
				
				
				last_msg_time = current_msg_time
				@buffer_pointer+=1
				
			end
			sleep(0.009)
			
		end
	end
end

class MidiChannel
	attr_accessor :pitchbend, :note_on, :note_off
	
	def initialize(pitchbend, note_on, note_off, control_change)
		@note_on = note_on
		@note_off = note_off
		@control = control_change
		@pitchbend = pitchbend
	end
end

