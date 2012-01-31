#!/usr/bin/env ruby

require_relative 'build_xml'
require_relative 'parse_thumbnail'
require_relative 'lib/plm/parse_plm'
require_relative 'lib/product_image_pull'
require_relative 'lib/colorways/colorway_parse'
require 'fileutils'


if __FILE__ == $0
  
  print "Path to thumbnail? "
  thumbnail_fileName = gets
  thumbnail_fileName = thumbnail_fileName.chomp

  xmlFilePath = "./XML/"
  inddTemplate = "./Template/CS_jpeg.indd"
  image_paths = Array.new
  image_paths << "./catalog_images/"
  image_paths << "./catalog_images_2/"
  
  plmData_fall = File.new("/Volumes/Creative_Services/Scripts/Ruby/Data/PLM_Info_fall", "r")
  plmData_spring = File.new("/Volumes/Creative_Services/Scripts/Ruby/Data/PLM_Info_spring", "r")
  defultProductData = File.new("/Volumes/Creative_Services/Scripts/Ruby/Data/productNotFound.csv", "r")
  colorwayData = File.new("/Volumes/Creative_Services/Scripts/PLM_Colorways/PLM_Colorways", "r")
  
  begin
    thumbnail_file = File.new(thumbnail_fileName, "r")
  rescue
    puts "Could not find thumbnail located at : #{thumbnail_fileName} - EXITING SCRIPT!!!"
    exit
  end

  catalogProducts = Hash.new
  
  thumbNail = ParseThumbnail.new(thumbnail_file)
  blankProduct = ParsePlm.new(defultProductData, false)
  fallPLM = ParsePlm.new(plmData_fall, false)
  springPLM = ParsePlm.new(plmData_spring, false)
  colorwayInfo = ColorwayParse.new(colorwayData)
  
  # Set up the corp_sales_jpeg object. This will handle finding and copying the FPO image into the FPO folder
  corpSalesJpeg = ProductImagePull.new(image_paths)
  
  thumbNail.products.each do | style_number, product | 
    
    if product.season.downcase == "fall"
      plmDataObj = fallPLM
    else 
      plmDataObj = springPLM
    end
        
    # Test to see if the product from the thumbnail exists?
    if plmDataObj.data.has_key?(style_number)
      plmData = plmDataObj.data[style_number]
    else
      
      # If the product is not found set productHash to BlankProduct
      plmData =  blankProduct.data["00000"]
       
      # Since the product was not found substitute the thumbnail product name and styleNumber in 
      # for the Blank Product defaults.
      plmData.plmHash[:styleNumber] = style_number
      plmData.plmHash[:productName] = product.thumbnail_prodName
      
      puts "#{product.thumbnail_prodName} : #{style_number} was not found!"
      
    end
    
    product.setPlmData(plmData)
    
    # Build the catalogProducts hash
    product.pageNum.each do | pageNum |
      
      if catalogProducts.has_key?(pageNum) 
      
        catalogProducts[pageNum] << product
        
      else
        
        productHolder = Array.new
        productHolder << product
        catalogProducts[pageNum] = productHolder
        
      end
      
    end
    
    # Pull all the product images
    product.colorways.each do | styleNumber, colorways |
      colorways.each do | alpha |
                
        begin
          colorNum = colorwayInfo.colorways[alpha].number
        rescue
          colorNum = "XXX"
        end   
         
        findResult = corpSalesJpeg.get_image(styleNumber, alpha, colorNum, true)
        unless findResult then puts "Image Not Found : #{styleNumber}_#{alpha}!" end
       
      end    
    end
  end
  
  # Build the XML files
  catalogProducts.each do | pageNum, productArray |
    
     # Create the XML files
    xmlFileName = "#{xmlFilePath}#{pageNum}.xml"
    xmlFile = File.new(xmlFileName, File::CREAT|File::RDWR)
    
    xmlBuilder = BuildXml.new(productArray, xmlFile, pageNum, colorwayInfo)
    xmlBuilder.create_corp_sales_jpeg
    
    # Copy in the InDesign templage
    FileUtils.cp(inddTemplate, "./Indd/#{pageNum}.indd")
    
  end
end