require './word_note.rb'
class Program
	

	attr_accessor :program_id, :msg_map, :name
	
	def initialize(words, request_id, name)
		@name = name
		@program_id = request_id
		@msg_map = Hash.new
		
		midi_key = 1
		
		words.keys.each do |key|
			
			if midi_key == 128
				break			
			end
			
			@msg_map[midi_key] = WordNote.new(words[key], key.to_s)
			
			midi_key+=1
			
		end
	end
	
	def [](note)
		return @msg_map[note]
	end
	
end
