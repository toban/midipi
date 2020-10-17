#! /usr/bin/ruby
require File.join(File.dirname(__FILE__), '../src/word_note.rb')
class WordDB

	attr_accessor :doc, :map, :word_hash
	
	def initialize
		readfile(2000)
	end
	
	def readfile(maxRows)
		@doc = File.new(File.join(File.dirname(__FILE__), '../dictionary/codes.db'), 'r')
		count = 0
		
		@word_hash = []
		
		while ((line = doc.gets))

			if count > maxRows
				break
			end
		
			segment = line.to_s.split('|')
			
			code = segment[1].gsub("\n", "").split(',').map(&:to_i)

			@word_hash[count] = WordNote.new(code, segment[0])
			count+=1
		end

		puts @word_hash.count
	end

end

