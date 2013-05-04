#! /usr/bin/ruby
require 'wiringpi'
require './init.rb'



class MidiPi

	
	def initialize
		
	end
	
	def test
		$log.info("sending")
		s = WiringPi::Serial.new('/dev/ttyAMA0', 9600)
		s.serialPuts('\0')
		s.serialPuts('V')
		s.serialPuts('\A')
		s.serialClose
	end

end

midipi = MidiPi.new
midipi.test


