#! /usr/bin/ruby
require File.join(File.dirname(__FILE__), 'parse_cmu.rb')
require 'sqlite3'
require 'htmlentities'

class CreateDatabase

	attr_accessor :cmu_parser, :db
	
	def initialize
		@cmu_parser = CmuParser.new
		puts SQLite3
		@db = SQLite3::Database.new("cmu.db")
		@db.execute("CREATE TABLE IF NOT EXISTS words (word_stripped TEXT NOT NULL PRIMARY KEY, word_encoded TEXT, code TEXT NOT NULL);")
		puts "init database"
	end
	
	def seed
	encoder = HTMLEntities.new
	@cmu_parser.word_hash.keys.sort.each do |key|
			puts "#{key}-----"
			val = @cmu_parser.word_hash[key]
			
			@db.execute("INSERT OR IGNORE INTO words (word_stripped, word_encoded, code) VALUES ('%s', '%s', '%s');"  % [val.name.gsub(/[^0-9a-z ]/i, ''), encoder.encode(val.name), val.code.to_s])
			
		end
  
  end
	

end

c = CreateDatabase.new
c.seed
