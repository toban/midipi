# helper class for keeping track of midi messages on specific channels
class MidiChannel
	attr_accessor :pitchbend, :note_on, :note_off, :control_change
	
	def initialize(pitchbend, note_on, note_off, control_change)
		@note_on = note_on
		@note_off = note_off
		@control_change = control_change
		@pitchbend = pitchbend
	end
end
