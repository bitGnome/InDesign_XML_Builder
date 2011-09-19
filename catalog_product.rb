class CatalogProduct
  
  require_relative 'lib/plm/plm_data'
  
  attr_reader :pageNum, :styleNum, :thumbnail_prodName, :plm_data, :colorways, :feature_color, :season, :type, :copy_type, :section
  
  @colorways
  @styleNum 
  @season
  @pageNum
  @thumbnail_prodName
  @section
  
  def initialize(thumbnailRow)
    
    # Instance variables
    @pageNum = thumbnailRow[0]
    
    if thumbnailRow[1].to_s == ""
      @section = "NO SECTION"
    else
      @section = thumbnailRow[1]
    end
    
    @season = thumbnailRow[2] 
    @season = thumbnailRow[2]
    @styleNum = thumbnailRow[3]
    @thumbnail_prodName = thumbnailRow[4];
    @colorway = thumbnailRow[5]
    
    # Pull in the colorway information if the Alpha supplied in the thumbNail does not exists set defaults
    begin
      @type = thumbnailRow[7].upcase
    rescue
      @type = "X"
    end   
    
    @OM = thumbnailRow[8]
    @copy_type = thumbnailRow[10]
    
    # These 2 hashes will be used later in the insertColorways method
    @pageNum = Array.new
    @colorways  = Hash.new

  end
  
  def insertColorway(colorway, pageNum, colorList)
    
    if colorway.nil? 
      colorway = "XXX" 
      puts "Setting colorway to XXX for #{@styleNum}"
    end
    
    # Check to see if the hash exits
    unless (@colorways.has_key?(pageNum.to_s))
       
       # create a new array and push the colorway into it
      colorway_array = Array.new
      @colorways[pageNum.to_s] = colorway_array
      
      # Push the page number into the @pageNum array
      @pageNum.push(pageNum)
      
      @feature_color = colorway
    
    end
    
    # push the new colorway into the stack
    if colorList == "f"
      @colorways[pageNum.to_s].insert(0, colorway)
      @feature_color = colorway
    else 
       @colorways[pageNum.to_s].push(colorway);
    end

  end
  
  def listColorways
    
    puts "styleNum: " + @styleNum + " " + @colorways.length.to_s
    #@colorways.each{ |myColor| puts "myColor: " + myColor }
    
  end
  
  def setPlmData(plmData)
    @plm_data = plmData
  end

end