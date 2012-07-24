#!/usr/bin/env ruby
# encoding: utf-8

require 'fileutils'
require_relative 'lib/catalog/build_xml'
require_relative 'lib/catalog/parse_thumbnail'
require_relative 'lib/plm/parse_plm'
require_relative 'lib/catalog/product_image_pull'
require_relative 'lib/colorways/colorway_parse'
require_relative 'lib/utils/validate_path'

@priority_season
@secondary_season

if __FILE__ == $0
  
  # Verify all paths to data are valid
  fall_product_image_path = ValidatePath.new("/Users/brett_piatt/Devel/Product_Images/fall/")
  spring_product_image_path = ValidatePath.new("/Users/brett_piatt/Devel/Product_Images/spring/")
  plmData_path = ValidatePath.new("/Volumes/Creative_Services/Scripts/Ruby/Data/")
  colorwayData_path = ValidatePath.new("/Volumes/Creative_Services/Scripts/PLM_Colorways/")
  
  
  print "Catalog Name (Ex. HOL11)? "
  catalogName = gets.chomp
  
  print "Path to thumbnail? "
  thumbnail_fileName = gets.chomp
  
  print "Latin copy for all products (y|n)? "
  all_latin_copy = gets.chomp
  
  print "Pull EU prices and specs (y|n)? "
  eu_specs = gets.chomp
  
  if eu_specs.include?("y")
    eu_specs = true
  else
    eu_specs = false
  end
  
  if (all_latin_copy.downcase.include?("y"))
    only_latin_copy = true
  else
    only_latin_copy = false
    
    print "Pull only Carry In Copy (y|n)? "
    carry_in_copy_answer = gets.chomp
    
    if (carry_in_copy_answer.downcase.include?("y"))
      
      print "Which Season (fall|spring)? "
      season_carry_in = gets.chomp.downcase
    else
      season_carry_in = "false"
    end
    
  end
  
  # Check to see if FPO images are needed to be pulled
  print "Pull FPO images (y|n)? "
  pullFPO_answer = gets.chomp.downcase
  
  if (pullFPO_answer.include?("y"))
    
    # Check to see if an product_images directory already exists
    if (!Dir.exists?("./product_images"))
      FileUtils.mkdir("./product_images")
    end
     
    puts "Putting all FPO images in the product_images directory!"
     
    pullFPOImages = true
    
  else 
    pullFPOImages = false
  end
   
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
  
  # Check to see if a Catalog directory already exists
  if (Dir.exists?("./Catalog"))
    print "Catalog directory already exists! Delete Directory (y|n)? "
    deleteCatalogDir = gets.chomp.downcase;
    
    if deleteCatalogDir.include?("y")
      puts "Deleting Catalog directory!"
      FileUtils.rm_r './Catalog';
    else
      puts "Exiting Script!"
      Process.exit
    end
  end
  
  # Create the Catalog Directory
  FileUtils.mkdir './Catalog'
  
  missing_images = File.new("./missing_images.txt", "w")
  
  xmlFilePath = "./XML/"
  image_paths = Array.new
  image_paths << fall_product_image_path.path;
  image_paths << spring_product_image_path.path;
  
  puts ("plmData_path = #{plmData_path.path}")
  
  plmData_fall = File.new("#{plmData_path.path}PLM_Info_fall", "r")
  plmData_spring = File.new("#{plmData_path.path}PLM_Info_spring", "r")
  defultProductData = File.new("#{plmData_path.path}productNotFound.csv", "r")
  colorwayData = File.new("#{colorwayData_path.path}PLM_Colorways", "r")
  
  begin
    thumbnail_file = File.new(thumbnail_fileName, "r")
  rescue
    puts "Could not find thumbnail located at : #{thumbnail_fileName} - EXITING SCRIPT!!!"
    exit
  end

  catalogProducts = Hash.new
  
  thumbNail = ParseThumbnail.new(thumbnail_file)
  
  if (only_latin_copy)
    
    fallPLM = ParsePlm.new(plmData_fall, "latin")
    springPLM = ParsePlm.new(plmData_spring, "latin")
    
  else
    
    if (season_carry_in == "fall")
      fallPLM = ParsePlm.new(plmData_fall, "carry_in")
    else
      fallPLM = ParsePlm.new(plmData_fall, "all")
    end
    
    if (season_carry_in == "spring")
      springPLM = ParsePlm.new(plmData_spring, "carry_in")
    else
      springPLM = ParsePlm.new(plmData_spring, "all")
    end
    
  end
    
  colorwayInfo = ColorwayParse.new(colorwayData)
  
  # Set up the CatalogFPO object. This will handle finding and copying the FPO image into the FPO folder
  catalogFPO = ProductImagePull.new(image_paths)
  
  thumbNail.products.each do | style_number, product | 
        
    if product.season.downcase == "fall"
      plmDataObj = fallPLM
      @priority_season = "fall"
      @secondary_season = "spring"
    else 
      plmDataObj = springPLM
      @priority_season = "spring"
      @secondary_season = "fall"
    end
        
    # Test to see if the product from the thumbnail exists?
    if plmDataObj.data.has_key?(style_number)
      plmData = plmDataObj.data[style_number]
    else
      puts "#{product.thumbnail_prodName} : #{style_number} was not found!"
      
      # If the product is not found set productHash to BlankProduct
      blankProduct = ParsePlm.new(defultProductData, "all")
      plmData =  blankProduct.data["0"]
       
      # Since the product was not found substitute the thumbnail product name and styleNumber in 
      # for the Blank Product defaults.
      plmData.plmHash[:styleNumber] = style_number
      plmData.plmHash[:productName] = product.thumbnail_prodName
      
    end
    
    product.setPlmData(plmData)
    
    # Loop through the pageNum array in the product object
    product.pageNum.each do | pageNum |
      
      if catalogProducts.has_key?(pageNum) 
      
        catalogProducts[pageNum] << product
        #puts "Pushig a new product into the productHolder array on pageNum : #{pageNum}"
        
      else
        
        #puts "Creating a new catalogProduct entry for pageNum : #{pageNum}"
        productsHolder = Array.new
        
        productsHolder << product
        
        catalogProducts[pageNum] = productsHolder
        
      end
      
    end
    
    # Pull in the colorway information if the Alpha supplied in the thumbNail does not exists set defaults
    begin
      colorNum = colorwayInfo.colorways[product.feature_color].number
    rescue
      colorNum = "XXX"
    end   
    
    if (pullFPOImages && (product.type.downcase != "ll"))
      
      # puts "product.type == #{product.type}"
      # Pull in the FPO if one exists
      if style_number.nil? || product.feature_color.nil?
        findResult = false
      else
        findResult = catalogFPO.get_image(style_number,  product.feature_color, colorNum, false)
      end
      
      unless findResult 
        unless findResult then missing_images.puts "#{product.thumbnail_prodName} : #{style_number} - #{product.feature_color}"  end
      end 
    end
  end
  
  # Create the copy document
  copyFileName = "#{catalogName}_Copy.txt"
  copyFile = File.new(copyFileName, File::CREAT|File::RDWR)
    
  # Loop through the catalogProducts and build the XML files
  catalogProducts.each do | pageNum, productsArray |
    
     # Create the XML files
    xmlFileName = "#{xmlFilePath}#{catalogName}_#{pageNum}.xml"
    xmlFile = File.new(xmlFileName, File::CREAT|File::RDWR)
    
    xmlBuilder = BuildXml.new(productsArray, xmlFile, pageNum, colorwayInfo)
    xmlBuilder.create_catalog_xml(eu_specs)
    
    # Create the InDesign files
    FileUtils.mkdir("Catalog/#{pageNum}")
    
    # Check and see if the page is an editorial
    if (xmlBuilder.section.downcase =~ /edit/) then
      FileUtils.cp("./Template/editorial.indd", "Catalog/#{pageNum}/#{catalogName}_#{pageNum}.indd")
    else 
      FileUtils.cp("./Template/product.indd", "Catalog/#{pageNum}/#{catalogName}_#{pageNum}.indd")
    end
    
      # Write out the copy document
      copyFile.write("#{pageNum}\n")
      
      productsArray.each do | myProduct |
        if(!myProduct.plm_data.no_copy)
          copyFile.write("#{myProduct.plm_data.plmHash[:productName]} \n#{myProduct.plm_data.plmHash[:productCopy]} #{myProduct.plm_data.plmHash[:fit]}. #{myProduct.plm_data.plmHash[:countryOfOrigin]}.\n\n");
        end
      end
  end
  
  copyFile.close
 
end