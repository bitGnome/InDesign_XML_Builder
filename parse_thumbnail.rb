class ParseThumbnail
  
  require 'csv'
  require_relative 'catalog_product'
  
  attr_reader :products
  
  def initialize(thumbnail_data)
    
    @products = Hash.new
      
    # Loop through the catalog thumbnail and create the products Hash
    CSV.foreach(thumbnail_data) do | row |
      
      pageNum = row[0]
      styleNum = row[3]
      colorway = row[5]

      # Pull in the colorway information if the Alpha supplied in the thumbNail does not exists set defaults
      begin
        colorList = row[7].downcase
      rescue
        colorList = "x"
      end   
      
      
      # Check to see if the CatalogProduct was created
      if (@products.has_key?(styleNum.to_s))
        
        @products[styleNum.to_s].insertColorway(colorway, pageNum, colorList)
      
      # If the data is for "editorial don't create a CatalogProduct object
      #elsif (styleNum.to_s.downcase.match(/edit.+/) == nil)
      else
        product = CatalogProduct.new(row)
        
        # Push the colorway into the @colorways instance variable
        product.insertColorway(colorway, pageNum, colorList)
        
        # Store the object in catalogProducts
        @products[styleNum.to_s] = product
  
      end
      
    end
    
  end
  
end