# parse_cmu.rb
require File.join(File.dirname(__FILE__), '../util/parse_cmu.rb')

describe CmuParser, "init" do
  it "should read lines and not crash" do
	parser = CmuParser.new
	parser.word_hash.keys.count.should == 133315
        puts "ASDFFAS"
	puts parser.word_hash['CAT'].inspect
	puts parser.word_hash['ACID'].inspect
	puts parser.word_hash['MUSIC'].inspect
	puts parser.word_hash['GIVE'].inspect
	puts parser.word_hash['THE'].inspect
	puts parser.word_hash['TO'].inspect
	puts parser.word_hash['WATCH'].inspect
	puts parser.word_hash['IT'].inspect
	puts parser.word_hash['DANCE'].inspect
	puts parser.word_hash['FUCK'].inspect
	puts parser.word_hash['GO'].inspect
	puts parser.word_hash['CRAZY'].inspect
	puts parser.word_hash['ON'].inspect
  end
end
