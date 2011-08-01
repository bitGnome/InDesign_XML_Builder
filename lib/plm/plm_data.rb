class PlmData
  
  require_relative 'size_range'
  require_relative 'weight'
  require_relative 'country_of_origin'
  require_relative 'fit'
  require_relative 'bugs'
  
  attr_accessor :plmHash
  attr_accessor :no_copy
  
  def initialize(plmData, carry_in_copy_only)
    
    @plmHash = Hash.new
    @no_copy = false
    
    latin_copy = "Ris volupta volore, con pe re, et eius, te odi quaturero blabo. Itati unt vid magnistem eos evelique pra veriasi taturectius. Tur rest, quiam, quundio. Et officiae volorem. Fuga. Ut pa parum hil ma veniatem. Uscil mos minctorrorum quin cusant, untius mi, si autem aut landa di ute quis irum qui occuptaspid ut pre et vollupissit hilique ped evel mintest iundiciam et iduci.  con vel dolore eum dio odolortie dignit digna facipis amet ullan vent nismodio commodolore feugiat adip ea atem etum dolor sent loboreros eu feugait velissed dolesecte do od esecte magna autatue essequi smolobo rperit aliqui tat. Do dipsuscin ut vel ea feugiam consequisim iriure magnim iuscinibh ex el diat fit. Made in Sed Min Ulla Faccum Dolore Vel Ulput Luptat Volessi Blan Agnibh Ero Od Dio Dolortio Dipit Laortionsed Ex Et Num Zzriureet."
    
    # The order of this data is dependant on your PLM view!
    # See the page http://creative.lostarrow.com/index.php?option=com_content&task=view&id=9&Itemid=9
    # for PLM data order
    @plmHash[:styleNumber] = plmData[1]
    @plmHash[:productName] = plmData[2]
    @plmHash[:weight] = Weight.new(plmData[3].to_f)
    @plmHash[:price] = plmData[4]
    @plmHash[:sizeRange] = SizeRange.new(plmData[5])
    
    if plmData[6].to_s == ""
      @plmHash[:productCopy] = @latin_copy
      @no_copy = true
    else
      @plmHash[:productCopy] = plmData[6].to_s
    end

    @plmHash[:latin_copy] = latin_copy
    @plmHash[:fit] = Fit.new(plmData[7])
    @plmHash[:countryOfOrigin] = CountryOfOrigin.new(plmData[8])
    @plmHash[:team] = plmData[9]
    
    # Bug info
    bugs = Hash.new
    bugs[:bluesign] = plmData[10]
    bugs[:eFiber] = plmData[11]
    bugs[:polartec] = plmData[12]
    bugs[:goreTex] = plmData[13]
    bugs[:upf] = plmData[14]
    bugs[:status] = plmData[15]
    
    if (carry_in_copy_only)
      if (bugs[:status] != "Carry In")
        @plmHash[:productCopy] = latin_copy
        @no_copy = true
      end
    end
    
    @plmHash[:bugInfo] = Bugs.new(bugs)
    
  end
  
end