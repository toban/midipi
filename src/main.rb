#! /usr/bin/ruby
require File.join(File.dirname(__FILE__), 'midipi.rb')

midipi = MidiPi.new

threads = []
threads << MidiListener.new(midipi)
#threads << MCP3008.new(midipi, 0)

midipi.set_serial_mode
midipi.reset

while(true)
  for i in threads
    i.poll()
  end
end

midipi.release
