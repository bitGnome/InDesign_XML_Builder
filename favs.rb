#!/usr/bin/env ruby

require 'builder'

myFile = File.new("thisFile.xml", "w")

favorites = { 'candy'  => 'Neccos',
              'novel'  => 'Empire of the sun',
              'holiday'  => 'Easter'
            }
            
xml = Builder::XmlMarkup.new(:indent  => 2)

xml.instruct! :xml, :version  => "1.1", :encoding  => "US-ASCII"

xml.Root("xmlns:aid"  => "http://ns.adobe.com/AdobeInDesign/4.0/") {
  favorites.each do | name, choice |
    xml.favorite( choice, :item  => name)
  end
} 

xmlOutputFile = File.new("myFile.xml", File::CREAT|File::RDWR)

xmlOutputFile << xml