#!/usr/bin/env ruby

require 'csv'
require 'builder'
require_relative 'catalog_product'
require_relative 'parse_thumbnail'
require_relative 'plm_data'


if __FILE__ == $0
  
  catalogName = "HOL11"
  xmlFilePath = "./XML/"
  plmData = File.new("PLM_Info_fall2.csv", "r")
  thumbnail_file = File.new("HOL11_thumb.csv", "r")
  defultProductData = File.new("productNotFound.csv", "r")
  
  # Create a default product. which will be used if the PLM data is not found
  CSV.foreach(defultProductData) do |row|
     
     # Create a new PlmData object and store it in the plmDataHash with the styleNumber as the Key
     BlankProduct = PlmData.new(row)
     
  end

  plmDataHash = Hash.new
  #catalogHash = Hash.new
  colorwayHash = Hash.new
  
  thumbNail = ParseThumbnail.new(thumbnail_file)
  
# 
  # # Loop through the catalog thumbnail and create the catalogHash and build the colorway hash
  # CSV.foreach(catalogData) do |row|
#     
    # pageNum = row[0]
    # thumbnail_prodName = row[1];
    # season = row[2]
    # styleNum = row[3]
    # colorway = row[5]
#       
    # # Check to see if the CatalogProduct was created
    # if (catalogHash.has_key?(styleNum.to_s))
#       
      # catalogHash[styleNum.to_s].insertColorway(colorway, pageNum)
#     
    # # If the data is for "editorial don't create a CatalogProduct object
    # elsif (styleNum.to_s.downcase.match(/edit.+/) == nil)
# 
      # myObject = CatalogProduct.new(styleNum, season, thumbnail_prodName)
#       
      # # Push the colorway into the @colorways instance variable
      # myObject.insertColorway(colorway, pageNum)
#       
      # # Store the object in catalogProducts
      # catalogHash[styleNum.to_s] = myObject
# 
    # end
#     
  # end
#   

  # Loop through the PLM data and create the plmDataHash
  CSV.foreach(plmData) do |row|
     
     # Create a new PlmData object and store it in the plmDataHash with the styleNumber as the Key
     plmDataHash[row[1].to_s] = PlmData.new(row)
     
  end
 
  # catalogHash.each do | key, value | 
#     
#    
    # # Test to see if the product from the thumbnail exists?
    # if plmDataHash.has_key?(key)
      # productHash =  plmDataHash[key]
      # #puts "#{key} PLM prodName: #{plmDataHash[key].plmHash[:productName]} is on page :: #{value.pageNum}"
    # else
      # productHash =  BlankProduct
    # end
#     
    # value.pageNum.each do | pageNum |
#       
#       
# # 
      # # # Create the XML files
      # # xmlFileName = "#{xmlFilePath}#{catalogName}_#{pageNum}.xml"
# #       
      # # # Check to see if the XML file exists
      # # if File.exist?(xmlFileName) then
        # # puts "Adding #{productHash.plmHash[:productName]} to #{pageNum}"
        # # xmlFile = File.open(xmlFileName, 'a')
      # # else
        # # xmlFile = File.new(xmlFileName, File::CREAT|File::RDWR)
      # # end
# #       
# #       
      # # #xmlFile << productHash.plmHash[:productName] + "\n"
# #       
      # # xmlFile.close
# #       
# 
      # puts "pageNum :: #{pageNum} -> #{productHash.plmHash[:bugInfo].getBugInfo}"
#       
    # end
#     
  # end
#  
end