# parse_cmu.rb
require File.join(File.dirname(__FILE__), '../util/parse_cmu.rb')

describe CmuParser, "init" do
  it "should read lines and not crash" do
	parser = CmuParser.new
	parser.word_hash.keys.count.should == 133315
        puts "ASDFFAS"
	puts parser.word_hash['ICE'].inspect
	puts parser.word_hash['HOCKEY'].inspect
	puts parser.word_hash['YOU'].inspect
	puts parser.word_hash['MAKE'].inspect
	puts parser.word_hash['GOAL'].inspect
	puts parser.word_hash['GREAT'].inspect
	puts parser.word_hash['JOB'].inspect
  end
end
