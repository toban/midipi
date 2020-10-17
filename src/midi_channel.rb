# helper class for keeping track of midi messages on specific channels
class MidiChannel
	attr_accessor :pitchbend, :note_on, :note_off, :control_change, :channel
	
	def initialize(pitchbend, note_on, note_off, control_change, channel)
		@note_on = note_on
		@note_off = note_off
		@control_change = control_change
		@pitchbend = pitchbend
		@channel = channel
	end
end
