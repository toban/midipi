#! /usr/bin/ruby
require File.join(File.dirname(__FILE__), '../src/word_note.rb')
class WordDB

	attr_accessor :doc, :map, :word_hash
	
	def initialize
		readfile()
	end
	
	def readfile()
		@doc = File.new(File.join(File.dirname(__FILE__), '../dictionary/codes.db'), 'r')
		count = 0
		
		@word_hash = Hash.new
		
		while ((line = doc.gets))
		
			segment = line.to_s.split('|')
			
			code = segment[1].gsub("\n", "").split(',')

			@word_hash[segment[0]] = WordNote.new(code, segment[0])
			count+=1
		end

		puts @word_hash.keys.count
	end

end

