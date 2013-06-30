#! /usr/bin/ruby
require File.join(File.dirname(__FILE__), 'midipi.rb')

midipi = MidiPi.new

threads = []
threads << Thread.new {MidiListener.new(midipi).run} 

midipi.set_serial_mode
midipi.reset


threads.each { |t| t.join }
midipi.release
