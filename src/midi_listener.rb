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
						lsbvalue = getNextCommand(msg)
						msbvalue = getNextCommand(msg)
						midipi.command_pitch(msbvalue.nil? ? 0 : msbvalue, lsbvalue.nil? ? 0 : lsbvalue )
						next
						
					end
					
					if command == @midichan.control_change
						puts "data: %s, timestamp: %s" % [msg[:data], msg[:timestamp]]
						
						control = getNextCommand(msg)
						value = getNextCommand(msg)
						
						value = value.nil? ? 114 : value
						
						case control
							when 14
								midipi.command_speed(value)
							when 15
								midipi.command_bend(value)
						end
						
						next
					end
					
					if command == @midichan.note_on
					
						note = nil
						note = getNextCommand(msg)
						
						if(!note.nil?)
							
							case note
							
							when 1
								puts "touch"
								midipi.speech("touch")
							when 2 
								puts "that"
								midipi.speech("that")
							when 3
								puts "ass"
								midipi.speech("ass") 
							when 4
								midipi.speech("stay") 
							when 5
								midipi.speech("a") 
							when 6
								midipi.speech("while") 
							when 7
								midipi.speech("forever")
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
	attr_accessor :pitchbend, :note_on, :note_off, :control_change
	
	def initialize(pitchbend, note_on, note_off, control_change)
		@note_on = note_on
		@note_off = note_off
		@control_change = control_change
		@pitchbend = pitchbend
	end
end

