# helper class for keeping track of midi messages on specific channels
class GuiManager
	attr_accessor :encoder, :mode, :midipi, :select_word_index, :selected_word
	
	def initialize(encoder, midipi)
		@encoder = encoder
		@mode = GUI_MODE::SELECT_WORD
		@midipi = midipi
		set_mode(@mode)
	end

	def set_mode(mode)
		@mode = mode
		case @mode
		when GUI_MODE::SELECT_WORD
			if not @midipi.dictionaries.empty?
				@encoder.set_params(0, @midipi.dictionaries[0].word_hash.count)
			end
		end

	end

	def poll()
		direction = @encoder.poll()
		@select_word_index = @encoder.get_round_value() 

		case @mode
		when GUI_MODE::SELECT_WORD
			if not @midipi.dictionaries.empty?
				word = @midipi.dictionaries[0].word_hash[@select_word_index]
				if word != @selected_word
					puts word.name
					@selected_word = word
					#puts @select_word_index
				end
			end
		end
	end
end
