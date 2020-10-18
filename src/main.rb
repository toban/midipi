#! /usr/bin/ruby
require File.join(File.dirname(__FILE__), 'midipi.rb')
require File.join(File.dirname(__FILE__), 'phrase_builder.rb')
require 'optparse'


options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: example.rb [options]"

  opts.on("-mMSG", "--message=MSG", "try to build the phrase") do |n|
    options[:msg] = n.split(' ')
  end

end.parse!

p options
p ARGV


midipi = MidiPi.new
phraseBuilder = nil

if options.key?(:msg)
	midipi.init_dictionary()
	phraseBuilder = PhraseBuilder.new(midipi, options[:msg])
end

midipi.set_mode(MIDIPI_MODE::PLAY_MODE)

threads = []
threads << midipi
#threads << MCP3008.new(midipi, 0)

midipi.set_serial_mode
midipi.reset

'''
 Send "\0"
 Send "8J"  (Set address for Envelope Control)
 Send "0N"  (Set Envelope Control to 0)
 Send "11J"  (Set address for Oscillator 1 Volume)
 Send "16N"  (Set Oscillator 1 Volume to 16)
 Send "1J"  (Set address for Oscillator 1 Frequency)
 Send "500N"  (Set Frequency of Oscillator 1 to 500 Hz)
 Send "1500N"  (Set Frequency of Oscillator 1 to 1500 Hz)
 Send "2500N"  (Set Frequency of Oscillator 1 to 2500 Hz
'''

#sleep(0.5)
#puts midipi.gpio.methods - Object.methods

#phrases
while( not phraseBuilder.nil? )
	phraseBuilder.phrase.each do |word|
		puts word.name
		#midipi.command_speed(Random.new.rand(255))
		midipi.command_bend(Random.new.rand(127))
		midipi.speech(word.code)
		print(word.code)
		sleep(2)
		midipi.stop_speaking

	end
end

# words
'''
midipi.dictionaries.first.word_hash.each do |word|
	puts word.name
	#midipi.command_speed(Random.new.rand(255))
	midipi.command_bend(Random.new.rand(127))
	midipi.speech(word.code)
	print(word.code)
	sleep(2)
	midipi.stop_speaking

end
'''
'''
v = 127.0
while(true)
	v = midipi.lerp(v, 0.0, 0.1)
	midipi.set_master_vol(v.to_i)
		midipi.set_osc_freq(5, v)
		midipi.set_osc_freq(4, v*v)
	sleep(0.1)

	puts v
	if(Random.new.rand(100) > 80)
	
		v = 127
	end
end
'''
'''
	#midipi.set_osc_freq(5, 200)
	

	
	for fq in 200..400
		midipi.set_osc_freq(5, fq)
		midipi.set_osc_freq(4, fq*2)
		sleep(0.05)
	end
	
	#sleep(0.05)
end
'''
'''
# effects
for  i in 200..254
	midipi.command_speed(Random.new.rand(255))
	midipi.command_bend(Random.new.rand(127))
	midipi.speech([i])
	sleep(1)
end
'''
#midipi.speech([174, 8, 14, 134, 170, 8, 134, 145, 194, 147, 8, 14, 137, 191, 200, 201, 202, 203, 204])


#main loop
while(true)
  for i in threads
    i.poll()
  end
end

midipi.release
