class CatalogProduct
  
  attr_accessor :pageNum, :styleNum
  
  @colorways
  @styleNum 
  @season
  @pageNum
  @thumbnail_prodName
  
  def initialize(styleNum, season, thumbnail_prodName)
    
    # Instance variables
    @styleNum = styleNum
    @season = season
    @thumbnail_prodName = thumbnail_prodName
    
    # These 2 hashes will be used later in the insertColorways method
    @pageNum = Array.new
    @colorways  = Hash.new

  end
  
  def insertColorway(colorway, pageNum)

    # Check to see if the hash exits
    if (@colorways.has_key?(pageNum.to_s))
       
       # push the new colorway into the stack
       @colorways[pageNum.to_s].push(colorway);
    
    # The else block will handle product that may be double exposed in a catalog
    else
      
      # create a new array and push the colorway into it
      colorway_array = Array.new
      colorway_array.push(colorway)
      @colorways[pageNum.to_s] = colorway_array
      
      # Push the page number into the @pageNum array
      @pageNum.push(pageNum)
    
    end
    
  end
  
  def listColorways
    
    puts "styleNum: " + @styleNum + " " + @colorways.length.to_s
    #@colorways.each{ |myColor| puts "myColor: " + myColor }
    
  end

end