#! /usr/bin/ruby
require File.join(File.dirname(__FILE__), '../src/word_note.rb')
class CmuParser

	attr_accessor :doc, :map, :word_hash
	
	def initialize
		@doc = File.new(File.join(File.dirname(__FILE__), '../dictionary/cmudict.0.7a.txt'), 'r')
		count = 0
		init_map
		@word_hash = Hash.new
		
		while ((line = doc.gets))
		
			segment = line.to_s.split('  ')
			code = get_segment_matches(segment[1]).to_s
			
			@word_hash[segment[0]] = WordNote.new(code, segment[0])
			count+=1
		end
		puts @word_hash.keys.count
	end
	
	def get_segment_matches(segment)
		
		code = []
		segment_chunks = segment.split(' ')
		
		segment_chunks.each do |chunk|
		
		if !@map.has_key?(chunk)
			raise "not found %s" % chunk
		end
		
		code.concat(@map[chunk])
		
		end
		
		return code
		
	end
	
	def init_map
	@map = {
	'AA' => [135],
	'AA0' => [8, 135],
	'AA1' => [8, 14, 135],
	'AA2' => [8, 14, 135],
	
	'AE' => [132],
	'AE0' => [8,132],
	'AE1' => [8, 14, 132],
	'AE2' => [8,14, 132],
	
	'AH' => [134],
	'AH0' => [8, 134],
	'AH1' => [8, 14, 134],
	'AH2' => [8, 14, 134],
	
	'AO' => [135],
	'AO0' => [8,135],
	'AO1' => [8, 14, 135],
	'AO2' => [8, 14, 135],
	
	'AW' => [163],
	'AW0' => [8,14, 163],
	'AW1' => [8,14, 163],
	'AW2' => [8, 14, 163],
	
	'AY' => [155],
	'AY0' => [8, 155],
	'AY1' => [8, 14, 155],
	'AY2' => [8, 14, 155],
	
	'B' => [170],
	'CH' => [182],
	'D' => [174],
	'DH' => [8, 169],
	
	'EH' => [131],
	'EH0' => [8, 131],
	'EH1' => [8,14,131],
	'EH2' => [8,14,131],
	
	'ER' => [176],
	'ER0' => [8,176],
	'ER1' => [8,14,176],
	'ER2' => [8,14,176],
	
	'EY' => [130],
	'EY0' => [130],
	'EY1' => [130],
	'EY2' => [130],
	
	'F' => [186],
	'G' => [179],
	'HH' => [183],
	
	'IH' => [129],
	'IH0' => [8, 129],
	'IH1' => [8,14, 129],
	'IH2' => [8,14, 129],
	
	'IY' => [128],
	'IY0' => [8, 128],
	'IY1' => [8, 128],
	'IY2' => [8, 128],
	
	'JH' => [165],
	'K' => [194],
	'L' => [145],
	'M' => [140],
	'N' => [141],
	'NG' => [143],
	
	'OW' => [137],
	'OW0' => [8,137],
	'OW1' => [8,14,137],
	'OW2' => [8,14,137],
	
	'OY' => [156],
	'OY0' => [8,156],
	'OY1' => [8,14,156],
	'OY2' => [8,14,156],
	
	'P' => [198],
	'R' => [148],
	'S' => [187],
	'SH' => [189],
	'T' => [191],
	'TH' => [190],
	
	'UH' => [138],
	'UH0' => [8,138],
	'UH1' => [8,14,138],
	'UH2' => [8,14,138],
	
	'UW' => [139],
	'UW0' => [8,139],
	'UW1' => [8,14,139],
	'UW2' => [8,14,139],
	
	'V' => [166],
	'W' => [147],
	'Y' => [158],
	'Z' => [167],
	'ZH' => [168],
	}
	end

end

