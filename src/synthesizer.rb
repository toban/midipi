class Synthesizer
	attr_accessor :freqs, :volumes, :osc_active, :midipi
	
	def initialize(midipi)
		@midipi = midipi
		@freqs = []
		@volumes = []
		@osc_active = []
		
		for i in 0..4
			@freqs[i] = 0
			@volumes[i] = 0
			@osc_active[i] = true
		end
		@freqs = [0,0,0,0,0]
		@osc_active = [false, true, false, false, false]

	end

	def set_osc(freq)

		for i in 1..5
			if !@osc_active[i]
				next
			end
			freq = freq+@freqs[i]
			puts freq
			@midipi.set_osc_freq(i,freq)
		end

	end
end