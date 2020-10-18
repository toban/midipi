#! /usr/bin/ruby

class PhraseBuilder
	attr_accessor :message, :midipi, :phrase
	
	def initialize(midipi, message)
		@midipi = midipi
		@message = message
		@phrase = []
		buildFromMessage()
	end

	def buildFromMessage()
		@message.each do |word|
			if @midipi.dictionaries[0].map.key?(word)
				wordIndex = @midipi.dictionaries[0].map[word]
				note = @midipi.dictionaries[0].word_hash[wordIndex]
				@phrase << note
			end
		end

		write
	end
'''
$programs << Program.new(
{
	:cat	 => [194, 8, 14, 132, 191],
	:acid  => [8, 14, 132, 187, 8, 129, 174],
	:music => [140, 158, 8, 14, 139, 167, 8, 129, 129, 194],
	:meau => [140, 8, 128, 135, 187, 191],
	:fuck => [186, 8, 14, 134, 194],

	:watch => [147, 8, 14, 135, 182],
	:it => [8, 14, 129, 191],
	:go => [179, 8, 14, 137],
	:crazy => [194, 148, 130, 167, 8, 128],

	:the => [8, 169, 8, 134],
	:give => [179, 8, 14, 129, 166],
	:dance => [174, 8, 14, 132, 141, 187],
	:on => [8, 14, 135, 141],




},7, "cats")

'''
	def write()
		puts
		puts
		puts '$programs << Program.new('
		puts '{'
		@phrase.each do |word|
			puts "\t" + ':'+word.name.downcase + "\t => " + word.code.inspect + ','
		end
		puts '},7, "Untitled program")'
		puts
		puts
	end
end
