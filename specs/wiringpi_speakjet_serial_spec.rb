# bowling_spec.rb
require 'wiringpi'
require './src/midipi.rb'

describe MidiPi, "input" do
  it "should do serial tx rx with speakjet" do
	midipi = MidiPi.new
	midipi.reset
	midipi.speech([194, 134, 140, 7, 198, 7, 160, 191, 133, 148])
	pin = 17
	puts midipi.gpio.mode(pin,INPUT)
	
	for i in 0..100
		
		puts midipi.gpio.read(pin)
	end
	
  end
end
