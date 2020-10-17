# helper class for keeping track of midi messages on specific channels
class RotaryEncoder
	attr_accessor :pin_a, :pin_b, :value, :sum, :encoded, :last_encoded, :gpio, :min, :max
	
	DIRECTION_POSITIVE = 1
	DIRECTION_UNCHANGED = 0
	DIRECTION_NEGATIVE = -1

	def initialize(pina, pinb, gpio)
		@gpio = gpio
		@pin_a = pina
		@pin_b = pinb

		@min = 0
		@max = 1000

		@value = 0
		@sum = 0
		@last_encoded = 0
		@encoded = 0

		@gpio.pin_mode(@pin_a, WiringPi::INPUT)
		@gpio.pin_mode(@pin_b, WiringPi::INPUT)
		@gpio.pull_up_dn_control(@pin_a, WiringPi::PUD_UP)
		@gpio.pull_up_dn_control(@pin_b, WiringPi::PUD_UP)
	end

	def set_params(min, max)
		@value = 0
		@last_encoded = 0
		@encoded = 0
		@sum = 0

		@min = min * 2
		@max = max * 2
	end

	def get_round_value()
		val = (value/2.0).round
		return value < @max ? val : (@max/2.0).round
	end

	def poll()
		msb = @gpio.digital_read(@pin_a) # Read from pin a
		lsb = @gpio.digital_read(@pin_b) # Read from pin b
		
		return_value = RotaryEncoder::DIRECTION_UNCHANGED

		@encoded = (msb << 1) | lsb
		@sum = (@last_encoded << 2) | @encoded
	    
	    if(@sum == 0b1101 || @sum == 0b0100 || @sum == 0b0010 || @sum == 0b1011)
	    	@value+=1
	    	return_value = RotaryEncoder::DIRECTION_POSITIVE
	    end
	    if(@sum == 0b1110 || @sum == 0b0111 || @sum == 0b0001 || @sum == 0b1000) 
	    	@value-=1
	    	return_value = RotaryEncoder::DIRECTION_NEGATIVE
	    end

	    @last_encoded = @encoded
	    
	    if(@value > @max)
	    	@value = @max
	    elsif @value < min
	    	@value = min
	    end



	    return return_value
	end
end
