require 'unimidi' 
require File.join(File.dirname(__FILE__), 'midi_channel.rb')
require File.join(File.dirname(__FILE__), 'synthesizer.rb')

#
# midi listener uses UniMidi to listen for messages and tell midipi what to do
class MidiListener
attr_accessor :input, :synthesizer, :midi_freqs, :buffer_pointer, :midipi, :msg_mean_time, :channels, :listening_channel, :cmd_i, :program

def initialize(midipi)

	# todo, either programchange or midichannel
	@program = 8
	$log.info("midilistener: program is %s" % @program)
	@midipi = midipi
	@midi_freqs = []
	@synthesizer = Synthesizer.new(midipi)

	a = 440; # a is 440 hz...
	x = 0
	for x in 0..127
		@midi_freqs[x] = (a / 32.0) * (2.0 ** ((x - 9.0) / 12.0));
	end

	begin
		@input = UniMIDI::Input.use(:first)
		$log.info("midilistener: midi device %s" % @input.inspect)

		@buffer_pointer = 0

		@channels = Array.new
		for i in 0..15
				@channels << MidiChannel.new(224+i,144+i, 128+i, 176+i, i)
		end
		
		@midichan = @channels[0]

		$log.info("midilistener: channel is %s" % @midichan.channel)
		$log.info("midilistener: note_on is %s" % @midichan.note_on)


	rescue
		$log.error("midilistener: FAILED TO CONNECT NO MIDI")    
	
	end

	
	
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
def poll(mode)

	#$log.info("midilistener: poll %s" % mode)

	buffer_length = 0
	last_msg_time = Time.now
	current_msg_time = Time.now
	
	if @input == nil
		return
	end

	buffer_length = @input.buffer.length
	
	while buffer_length > @buffer_pointer

		msg = @input.buffer[@buffer_pointer]
		#$log.info("midilistener: msg %s" % msg.inspect)

		
		current_msg_time = Time.now
		
		for @cmd_i in 0..msg[:data].length-1
			
			command = msg[:data][@cmd_i]
			case command
				when 248
					next
				when @midichan.pitchbend
				   	lsbvalue = getNextCommand(msg)
					msbvalue = getNextCommand(msg)

				   	case mode
				   		when MIDIPI_MODE::SYNTHESIZER_MODE
				   		when MIDIPI_MODE::PLAY_MODE
							midipi.command_pitch(msbvalue.nil? ? 0 : msbvalue, lsbvalue.nil? ? 0 : lsbvalue )
				   		when MIDIPI_MODE::TRIGGER_MODE
				   	end
				
					next

				when @midichan.control_change
					puts "CC data: %s, timestamp: %s" % [msg[:data], msg[:timestamp]]
					
					control = getNextCommand(msg)
					value = getNextCommand(msg)
					
					value = value.nil? ? 114 : value

					puts value
				   	#case mode
				   	#	when MIDIPI_MODE::TRIGGER_MODE || MIDIPI_MODE::PLAY_MODE
					case control
						when midipi.MIDIPI_SPEED_MESSAGE
								midipi.command_speed(value)
						when midipi.MIDIPI_PITCH_MESSAGE
								midipi.command_bend(value)
					end
				   	#end
					
	
					
					next
				when @midichan.note_on
										
					note = nil
					note = getNextCommand(msg)
					$log.info("midilistener: note %s" % note)

				   	case mode
				   		when MIDIPI_MODE::SYNTHESIZER_MODE
							freq = @midi_freqs[note.to_i].to_i

							synthesizer.set_osc(freq)
				

				   		when MIDIPI_MODE::PLAY_MODE

							if(!note.nil?)
								midipi.speech_program(@program, note)
							end
				   		when MIDIPI_MODE::TRIGGER_MODE
				   	end

					next
				end

		end
		
		last_msg_time = current_msg_time
		@buffer_pointer+=1
		
	end
	#sleep(0.001) # make the while loop less cpu intense
			

end
end
