class CatalogFPO
  
  require 'find'
  require 'fileutils'
  
  def initialize(springImage_path, fallImage_path)
    @springImageList = buildFileList(springImage_path)
    @fallImageList = buildFileList(fallImage_path)
  end
  
  def get_image(season, style_number, alpha, colorNum )
    
    if season == "fall"
      imageLocation = @fallImageList
    else 
      imageLocation = @springImageList
    end
    
    imageList = Array.new
    imageFound = false
    
    if alpha.nil?
      alpha = "XXX"
    end
    
    imageAlpha = "#{style_number}_#{alpha}"
    imageColorNum =  "#{style_number}_#{colorNum}"
    
    
   
    # Initially look in the priority and secondary directory for feature color
    imageLocation.each do | filePath |
      
      unless imageFound
        # First look for a feature color
        if filePath.include? imageAlpha
          FileUtils.cp(filePath, "./FPO/#{style_number}.jpg")
          imageFound = true
        elsif filePath.include? imageColorNum
          FileUtils.cp(filePath, "./FPO/#{style_number}.jpg")
          imageFound = true
        elsif filePath.include? style_number
          FileUtils.cp(filePath, "./FPO/#{style_number}.jpg")
          imageFound = true
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