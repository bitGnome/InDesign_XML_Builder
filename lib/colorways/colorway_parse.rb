class ColorwayParse
  
  require 'csv'
  require_relative 'colorway'
  
  attr_reader :colorways
  
  def initialize(colorwayData)
    
    @colorways = Hash.new
    
    CSV.foreach(colorwayData) do | row |
      
      @colorways[row[1].to_s] = Colorway.new(row)
      
    end
    
  end
end