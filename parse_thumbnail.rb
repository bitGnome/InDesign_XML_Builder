class ParseThumbnail
  
  require 'csv'
  require_relative 'catalog_product'
  
  def initialize(thumbnail_data)
    
    @thumbnailProducts = Hash.new
      
    # Loop through the catalog thumbnail and create the thumbnailProducts Hash
    CSV.foreach(thumbnail_data) do |row|
      
      pageNum = row[0]
      thumbnail_prodName = row[1];
      season = row[2]
      styleNum = row[3]
      colorway = row[5]
      
      puts "styleNum : #{styleNum}"
        
      # Check to see if the CatalogProduct was created
      if (@thumbnailProducts.has_key?(styleNum.to_s))
        
        @thumbnailProducts[styleNum.to_s].insertColorway(colorway, pageNum)
      
      # If the data is for "editorial don't create a CatalogProduct object
      elsif (styleNum.to_s.downcase.match(/edit.+/) == nil)
  
        myObject = CatalogProduct.new(styleNum, season, thumbnail_prodName)
        
        # Push the colorway into the @colorways instance variable
        myObject.insertColorway(colorway, pageNum)
        
        # Store the object in catalogProducts
        @thumbnailProducts[styleNum.to_s] = myObject
  
      end
      
    end
    
  end
  
end