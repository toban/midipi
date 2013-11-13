require 'unimidi' 
require File.join(File.dirname(__FILE__), 'midi_channel.rb')

#
# midi listener uses UniMidi to listen for messages and tell midipi what to do
class MidiListener
	attr_accessor :input, :buffer_pointer, :midipi, :msg_mean_time, :channels, :listening_channel, :cmd_i, :program
	
	def initialize(midipi)
	
		# todo, either programchange or midichannel
		@program = 5
		
		@midipi = midipi
		@input = UniMIDI::Input.use(:first)
		@buffer_pointer = 0
		
		@channels = Array.new
		for i in 0..15
			@channels << MidiChannel.new(224+i,144+i, 128+i, 176+i)
		end
		
		@midichan = @channels[0]
		
		
	end
	
	# get the next command from message buffer item
	def getNextCommand(msg)
		if(@cmd_i+1 < msg[:data].length)
			@cmd_i+=1
			command = msg[:data][@cmd_i]
			return command
		end
		return nil
	end
	
	# iterate the UniMidi inputbuffer
	def run
		$log.info("listening")
		buffer_length = 0
		last_msg_time = Time.now
		current_msg_time = Time.now
		
		# main loop
		while true
		
			buffer_length = @input.buffer.length
			
			while buffer_length > @buffer_pointer
			
				msg = @input.buffer[@buffer_pointer]
				
				current_msg_time = Time.now
				
				for @cmd_i in 0..msg[:data].length-1
					
		 			command = msg[:data][@cmd_i]
		 			
		 			# timing message
					if command != 248
						#puts "data: %s, timestamp: %s" % [msg[:data], msg[:timestamp]]
					else
						#puts msg[:timestamp]
					end
					
					# midi pitchbend
					if command == @midichan.pitchbend
						lsbvalue = getNextCommand(msg)
						msbvalue = getNextCommand(msg)
						midipi.command_pitch(msbvalue.nil? ? 0 : msbvalue, lsbvalue.nil? ? 0 : lsbvalue )
						next
						
					end
					
					# midi cc messages
					if command == @midichan.control_change
						puts "data: %s, timestamp: %s" % [msg[:data], msg[:timestamp]]
						
						control = getNextCommand(msg)
						value = getNextCommand(msg)
						
						value = value.nil? ? 114 : value
						
						case control
							when midipi.MIDIPI_SPEED_MESSAGE
								midipi.command_speed(value)
							when midipi.MIDIPI_PITCH_MESSAGE
								midipi.command_bend(value)
						end
						
						next
					end
					
					# midi note on
					if command == @midichan.note_on
					
						note = nil
						note = getNextCommand(msg)
						
						if(!note.nil?)
							
							midipi.speech_program(@program, note)
						end
				
						next
					end
				end
				
				last_msg_time = current_msg_time
				@buffer_pointer+=1
				
			end
			sleep(0.009) # make the while loop less cpu intense
			
		end
	end
end
