class Colorway
  
  attr_reader :alpha, :number, :name, :season
  
  def initialize(colorwayLine)
    
    @number = colorwayLine[0]
    @alpha = colorwayLine[1]
    @name = colorwayLine[2]
    @season = colorwayLine[3]
    
  end
end