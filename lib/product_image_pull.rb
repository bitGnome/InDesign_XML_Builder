class ProductImagePull
  
  require 'find'
  require 'fileutils'
  
  def initialize(image_paths)
    
    @imagePathList = Array.new
    
    # Build the imagePathList based on the Array of directory paths passed in
    image_paths.each do | path |
      @imagePathList << buildFileList(path)
    end
  
  end
  
  def get_image( style_number, alpha, colorNum, featureColorOnly )
    
    imageList = Array.new
    imageFound = false
    
    #style_number = style_number.strip
    imageAlpha = (style_number + "_" + alpha).strip
    imageColorNum = (style_number + "_" + colorNum).strip
    
    # If only the feature color is pulled appedn _alpha to the product image
    if featureColorOnly
      product_image_name = "#{style_number}_#{alpha}.jpg"
    else
      product_image_name = "#{style_number}.jpg"
    end
          
    # Loop through the imagePathList and look for 
    @imagePathList.each do | filePaths |
            
      filePaths.each do | path |
              
        unless imageFound
          if path.include? imageAlpha
            FileUtils.cp(path, "./product_images/#{product_image_name}")
            imageFound = true
          elsif path.include? imageColorNum
            FileUtils.cp(path, "./product_images/#{product_image_name}")
            imageFound = true
          elsif ( (path.include? style_number) && (!featureColorOnly) )
            FileUtils.cp(path, "./product_images/#{product_image_name}")
            imageFound = true
            
          end
          
        end
        
      end
      
    end
    
    return imageFound    

  end
  
  private
  def buildFileList(filePath)
    
    resultList = Array.new
    
    #puts "path : #{path}"
    
    Find.find(filePath) do | f |
      
      if File.file?(f)
        resultList << f
      end
    end
    
    return resultList
    
  end
  
end