class PlmData
  
  require_relative 'lib/plm/size_range'
  require_relative 'lib/plm/weight'
  require_relative 'lib/plm/country_of_origin'
  require_relative 'lib/plm/fit'
  require_relative 'lib/plm/bugs'
  
  attr_reader :plmHash

  def initialize(plmData)
    
    @plmHash = Hash.new
    
    # The order of this data is dependant on your PLM view!
    # See the page http://creative.lostarrow.com/index.php?option=com_content&task=view&id=9&Itemid=9
    # for PLM data order
    @plmHash[:styleNumber] = plmData[1]
    @plmHash[:productName] = plmData[2]
    @plmHash[:weight] = Weight.new(plmData[3].to_f)
    @plmHash[:price] = plmData[4]
    @plmHash[:sizeRange] = SizeRange.new(plmData[5])
    @plmHash[:productCopy] = plmData[6].to_s
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
    
    @plmHash[:bugInfo] = Bugs.new(bugs)
    
  end
  
end