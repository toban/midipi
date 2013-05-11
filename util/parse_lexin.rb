#! /usr/bin/ruby
require 'rexml/document'
doc = REXML::Document.new File.new('../dictionary/LEXIN.xml')
puts doc.elements('*/lemma-entry').count #{ |element| puts element.get_text }
