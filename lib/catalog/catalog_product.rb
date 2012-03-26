class CatalogProduct
  
  require_relative '../plm/plm_data'
  require_relative '../plm/size_range'
  
  attr_reader :pageNum, :styleNum, :thumbnail_prodName, :plm_data, :colorways, :feature_color, :season, :type, :copy_type, :section
  attr_reader :eu_size_range, :euro, :pound
  
  @colorways
  @styleNum 
  @season
  @pageNum
  @thumbnail_prodName
  @section
  
  def initialize(thumbnailRow)
    
    # Instance variables
    @pageNum = thumbnailRow["page"]
    
    if thumbnailRow["season"].to_s.eql?("")
      @section = "NO SECTION"
    else
      @section = thumbnailRow["section"]
    end

    if thumbnailRow["season"].downcase.include?("fall")
      @season = "fall"
    else
      @season = "spring"
    end
    
    @styleNum = thumbnailRow["style #"]
    @thumbnail_prodName = thumbnailRow["style description"]
    @colorway = thumbnailRow[5]    
    
    # Pull in the colorway information if the Alpha supplied in the thumbNail does not exists set defaults
    begin
      @type = thumbnailRow["feature"].upcase
    rescue
      @type = "X"
    end   
    
    #@OM = thumbnailRow[8]
    
    @copy_type = thumbnailRow["copy_type"]
    
    unless thumbnailRow["eu_sizes"].nil?
      size_range = SizeRange.new()
      @eu_size_range = size_range.catalog_format(thumbnailRow["eu_sizes"])
    end
    
    unless thumbnailRow["euro"].nil?
      @euro = thumbnailRow["euro"]
    end
    
    unless thumbnailRow["pound"].nil?
      @pound = thumbnailRow["pound"]
    end
    
    # These 2 hashes will be used later in the insertColorways method
    @pageNum = Array.new
    @colorways  = Hash.new

  end
  
  def insertColorway(colorway, pageNum, colorList)
    
    if colorway.nil? 
      colorway = "XXX" 
      #puts "Setting colorway to XXX for #{@styleNum}"
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