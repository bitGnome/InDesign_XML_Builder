#!/usr/bin/env ruby

require 'fileutils'

require_relative 'lib/workbook/parse_workbook_csv'
require_relative 'lib/workbook/workbook_bugs'
require_relative 'lib/workbook/workbook_xml'

# set up all the product bugs
@workbook_bug_path_lag = "/Volumes/Creative_Services/Workbook/S13_Workbook/xx_Bugs/"
@workbook_bug_path_usb = "/Volumes/Creative_Services/Workbook/S13_Workbook/xx_Bugs/USB/"

print "XML Output Name? "
xml_file_name = gets.chomp

unless Dir.exists?("./XML")
  FileUtils.mkdir './XML'
end

print "Path to CSV file? "
csv_file_name = gets.chomp

begin
  csv_file = File.new(csv_file_name, "r")
rescue
  puts "Could not find workbook csv located at : #{csv_file_name} - EXITING SCRIPT!!!"
  exit
end

print "Workbook version (USB or LAG)? "
@workbook_version = gets.chomp.downcase

if @workbook_version.eql? "lag"
  
  unless Dir.exists?("./XML/LAG")
    FileUtils.mkdir './XML/LAG'
  end
  
  xml_file = File.new("XML/LAG/#{xml_file_name}", File::CREAT|File::RDWR)
  @workbook_bug_path = @workbook_bug_path_lag
  
elsif @workbook_version.eql? "usb"
  
  unless Dir.exists?("./XML/USB")
    FileUtils.mkdir './XML/USB'
  end
  
  xml_file = File.new("XML/USB/#{xml_file_name}", File::CREAT|File::RDWR)
  @workbook_bug_path = @workbook_bug_path_usb
  
else
  puts "Workbook version must be either USB or LAG! EXITING!!!"
  exit
end

@workbook_bugs = WorkbookBugs.new
@workbook_bugs.path[:new] = @workbook_bug_path + "NEW.ai"
@workbook_bugs.path[:rev] = @workbook_bug_path + "REV.ai"
@workbook_bugs.path[:upf_50_plus] = @workbook_bug_path + "UPF50_plus.ai"
@workbook_bugs.path[:upf_50] = @workbook_bug_path + "UPF50.ai"
@workbook_bugs.path[:upf_40] = @workbook_bug_path + "UPF40.ai"
@workbook_bugs.path[:upf_35] = @workbook_bug_path + "UPF35.ai"
@workbook_bugs.path[:upf_30] = @workbook_bug_path + "UPF30.ai"
@workbook_bugs.path[:upf_25] = @workbook_bug_path + "UPF25.ai"
@workbook_bugs.path[:upf_20] = @workbook_bug_path + "UPF20.ai"
@workbook_bugs.path[:upf_15] = @workbook_bug_path + "UPF15.ai"
@workbook_bugs.path[:gore_tex] = @workbook_bug_path + "GoreTex.ai"
@workbook_bugs.path[:windstopper] = @workbook_bug_path + "WindStopper.ai"
@workbook_bugs.path[:h2no] = @workbook_bug_path + "H2No.ai"
@workbook_bugs.path[:bluesign] = @workbook_bug_path + "bluesign_approved.ai"
@workbook_bugs.path[:prima_loft] = @workbook_bug_path + "PrimaLoft.ai"
@workbook_bugs.path[:polartec] = @workbook_bug_path + "Polartec.ai"
@workbook_bugs.path[:e_style] = @workbook_bug_path + "E.ai"
@workbook_bugs.path[:regulator] = @workbook_bug_path + "R.ai"

workbook =  ParseWorkbookCsv.new(csv_file, @workbook_bugs, @workbook_version)

# Build the XML file
xml_builder = WorkbookXml.new(workbook.products, xml_file)

if @workbook_version.eql? "lag"
  xml_builder.build_LAG
else
  xml_builder.build_USB
end

#workbook.products.each do |style_number, product|
#  puts "workbook product :: #{product.product_data[:overview]} colorways :: #{product.colorways.name.length}"
#end