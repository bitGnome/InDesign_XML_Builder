class ParseThumbnail
  
  require 'csv'
  require_relative 'catalog_product'
  
  attr_reader :products
  
  def initialize(thumbnail_data)
    
    @products = Hash.new
    
    csv_data = CSV.read(thumbnail_data)
    headers = csv_data.shift.map {|i| i.to_s.downcase }
    string_data = csv_data.map {|row| row.map {|cell| cell.to_s } }
    thumbnail = string_data.map {|row| Hash[*headers.zip(row).flatten] }
    
    # Loop through the catalog thumbnail and create the products Hash
    thumbnail.each do | row |
      
      styleNum = row["style #"]
      
      unless styleNum.eql?("")
        pageNum = row["page"]
        colorway = row["color alpha"]
  
        # Pull in the colorway information if the Alpha supplied in the thumbNail does not exists set defaults
        begin
          colorList = row["feature"].downcase
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
  
end