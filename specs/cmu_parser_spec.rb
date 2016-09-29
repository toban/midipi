# parse_cmu.rb
require File.join(File.dirname(__FILE__), '../util/parse_cmu.rb')

describe CmuParser, "init" do
  it "should read lines and not crash" do
	parser = CmuParser.new
	parser.word_hash.keys.each do |key|
		puts key + "|" + (parser.word_hash[key].code)
	end 
	parser.word_hash.keys.count.should == 133315
	puts parser.word_hash['DISTRACT'].inspect
	puts parser.word_hash['DISTRACTING'].inspect
	puts parser.word_hash['DISTRACTIONS'].inspect
	puts parser.word_hash['DISTRACTED'].inspect
	puts parser.word_hash['AIR'].inspect
	puts parser.word_hash['INTERNET'].inspect
	puts parser.word_hash['WEBSITE'].inspect
	puts parser.word_hash['DOWNLOAD'].inspect
	puts parser.word_hash['FREE'].inspect
	puts parser.word_hash['WARES'].inspect
  end
end
