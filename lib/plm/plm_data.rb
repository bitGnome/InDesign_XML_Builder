class PlmData
  
  require_relative 'size_range'
  require_relative 'weight'
  require_relative 'country_of_origin'
  require_relative 'fit'
  require_relative 'bugs'
  
  attr_accessor :plmHash
  attr_accessor :no_copy
  
  def initialize(plmData, copy_option)
    
    @plmHash = Hash.new
    @no_copy = false
    @copy_option = copy_option
    
    
    latin_copy = "Ris volupta volore, con pe re, et eius, te odi quaturero blabo. Itati unt vid magnistem eos evelique pra veriasi taturectius. Tur rest, quiam, quundio. Et officiae volorem. Fuga. Ut pa parum hil ma veniatem. Uscil mos minctorrorum quin cusant."
    
    # The order of this data is dependant on your PLM view!
    # See the page http://creative.lostarrow.com/index.php?option=com_content&task=view&id=9&Itemid=9
    # for PLM data order
    @plmHash[:styleNumber] = plmData["Style Number"]
    @plmHash[:productName] = plmData["Marketing Name"]
    @plmHash[:weight] = Weight.new(plmData["Weight in Oz."].to_f)
    @plmHash[:price] = plmData["Published Retail Price"]
    
    if plmData["Size Range"].eql?("") then plmData["Size Range"] = "NO SIZE INFO" end
      
    size_range = SizeRange.new()
    @plmHash[:sizeRange] = size_range.catalog_format(plmData["Size Range"])
    
    if plmData["Product Copy"].to_s == ""
      @plmHash[:productCopy] = latin_copy
      @no_copy = true
    else
      @plmHash[:productCopy] = plmData["Product Copy"].to_s
    end

    @plmHash[:latin_copy] = latin_copy
    @plmHash[:fit] = Fit.new(plmData["Fit"])
    @plmHash[:countryOfOrigin] = CountryOfOrigin.new(plmData["Country of Origin"])
    @plmHash[:team] = plmData["Team"]
    
    # Bug info
    bugs = Hash.new
    bugs[:bluesign] = plmData["Bluesign Approved"]
    bugs[:eFiber] = plmData["E Style"]
    bugs[:polartec] = plmData["Polartec Product"]
    bugs[:goreTex] = plmData["Gore-Tex Primary"]
    bugs[:upf] = plmData["UPF Value"]
    bugs[:status] = plmData["Status"]
    
    if (@copy_option == "latin")
      @plmHash[:productCopy] = latin_copy
      @no_copy = true
    elsif (@copy_option == "carry_in")
      if (bugs[:status] != "Carry In")
        @plmHash[:productCopy] = latin_copy
        @no_copy = true
      end
    end
    
    @plmHash[:bugInfo] = Bugs.new(bugs)
    
  end
  
end