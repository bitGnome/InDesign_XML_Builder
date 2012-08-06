#!/usr/bin/env ruby

require_relative 'lib/catalog/build_xml'
require_relative 'lib/catalog/parse_thumbnail'
require_relative 'lib/plm/parse_plm'
require_relative 'lib/catalog/product_image_pull'
require_relative 'lib/colorways/colorway_parse'
require 'fileutils'

if __FILE__ == $0
  
  # Make sure the product_images_source directory exists
  unless Dir.exists?("./product_images_source")
    puts "You must collect all product jpegs and place them into the product_images_source directory! EXITING!"
    exit
  end
  
  # Set up the catalog images path.
  image_paths = Array.new
  image_paths << "./product_images_source/"
  
  # Check for the template file.
  unless File.exists?("./Template/CS_jpeg.indd")
    puts "Could not find the InDesign template file in ./Template/CS_jpeg.indd!"
    puts "You must first have the CS_jpeg.indd file placed in the Template folder before proceeding!"
    puts "EXITING SCRIPT!!!"
    exit
  end
  
  # Make sure the catalog_images directory exists
  unless Dir.exists?("./product_images")
    puts "Creating the ./product_images directory. All product images will be placed in this directory!"
    FileUtils.mkdir './product_images'
  end
  
  inddTemplate = "./Template/CS_jpeg.indd"
  
  print "Path to thumbnail? "
  thumbnail_fileName = gets
  thumbnail_fileName = thumbnail_fileName.chomp
  
  
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
  
  # Array to hold missing product information
  missing_products = Array.new
  
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
      plmData =  blankProduct.data["0"]
       
      # Since the product was not found substitute the thumbnail product name and styleNumber in 
      # for the Blank Product defaults.
      plmData.plmHash[:styleNumber] = style_number
      plmData.plmHash[:productName] = product.thumbnail_prodName
      
      puts "#{product.thumbnail_prodName} : #{style_number} was not found in the #{product.season.downcase} PLM Data source!!"
      
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
    product.colorways.each do | page_number, colorways |
      
      colorways.each do | alpha |
                
        begin
          colorNum = colorwayInfo.colorways[alpha].number
        rescue
          colorNum = "XXX"
        end   
         
        findResult = corpSalesJpeg.get_image(page_number, alpha, colorNum, true)
        unless findResult then missing_products << "#{page_number}_#{alpha}!" end
       
      end    
    end
  end
  
  # If all of the product images were found
  # Build the XML and InDesign files.
  if missing_products.count == 0
    
    # Make sure the Indd directory exists. This is where all the InDesign documents will be placed
    unless Dir.exists?("./Indd")
      puts "Creating the Indd directory. This is where all the InDesign documents will be placed.!"
      FileUtils.mkdir './Indd'
    end
    
    # Check for the XML directory. If it does exists all the XML should deleted.
    # Check to see if an XML directory already exists
    if (Dir.exists?("./XML"))
      print "XML directory already exists! Delete Directory (y|n)? "
      deleteXMLDir = gets.chomp.downcase;

      if deleteXMLDir.include?('y')
        puts "Deleting XML directory!"
        FileUtils.rm_r './XML'
      else 
        puts "Exiting Script!"
        Process.exit
      end
    end

    # Create the XML directory this will hold all the XML files
    FileUtils.mkdir './XML'

    xmlFilePath = "./XML/"
    
    catalogProducts.each do | pageNum, productArray |
    
       # Create the XML files
      xmlFileName = "#{xmlFilePath}#{pageNum}.xml"
      xmlFile = File.new(xmlFileName, File::CREAT|File::RDWR)
    
      xmlBuilder = BuildXml.new(productArray, xmlFile, pageNum, colorwayInfo)
      xmlBuilder.create_corp_sales_jpeg
    
      # Copy in the InDesign templage into the Indd directory
      FileUtils.cp(inddTemplate, "./Indd/#{pageNum}.indd")
    
    end
  else
    puts "* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *"
    puts "#{missing_products.count} product images are missing."
    puts "See the file missing_images.txt for the list."
    puts "Once all the missing images have been collected re-run the script"
    puts "to create the XML and InDesign files!"
    puts "* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *"
    
    missing_images = File.new("./missing_images.txt", "w")
    
    missing_products.each do |product|
      missing_images.puts product
    end
    
  end
end