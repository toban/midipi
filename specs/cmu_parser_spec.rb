# parse_cmu.rb
require File.join(File.dirname(__FILE__), '../util/parse_cmu.rb')

describe CmuParser, "init" do
  it "should read lines and not crash" do
	parser = CmuParser.new
	parser.word_hash.keys.count.should == 133315
	puts parser.word_hash['CALCULATE'].inspect
	puts parser.word_hash['TRANSFORM'].inspect
  end
end
