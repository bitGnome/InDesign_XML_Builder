#!/usr/bin/env ruby

  require_relative 'lib/hangtags/joker_csv_parse'
  require_relative 'lib/hangtags/joker'
  require_relative 'lib/hangtags/build_joker_xml'
  require_relative 'lib/hangtags/joker_template_builder'

  print "Path to the joker csv? "
  joker_fileName = gets.chomp
  
  begin
    joker_csv = File.new(joker_fileName, "r")
  rescue
    puts "Could not find thumbnail located at : #{joker_fileName} - EXITING SCRIPT!!!"
    exit
  end
  
  joker_parse = JokerCsvParse.new(joker_csv)
  jokers = Array.new
  
  joker_parse.jokers.each do |joker_data|
    jokers << Joker.new(joker_data)
  end
  
  jokers.each do |joker|
    
    joker_xml = BuildJokerXml.new(joker)
    joker_xml.build
    
    JokerTemplateBuilder.new(joker)
    
  end
  