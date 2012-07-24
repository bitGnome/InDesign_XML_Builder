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
      
      unless row["style #"].eql?("")
                
        styleNum = row["style #"]

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
            
          product = @products[styleNum.to_s]
          
        else
            
          # Store the object in catalogProducts
          @products[styleNum.to_s] = CatalogProduct.new(row)
    
        end
          
        unless colorList.eql?("n")
          # Push the colorway into the @colorways instance variable
          @products[styleNum.to_s].insertColorway(colorway, pageNum, colorList) 
        end
          
      end
  
    end
  end
  
end