class Colorway
  
  attr_reader :alpha, :number, :name, :season
  
  def initialize(colorway_line, number_header, alpha_header, name_header)
    
    @number = "%03d" % colorway_line["Color Numeric"]
    @alpha = colorway_line[alpha_header]
    @name = colorway_line[name_header]
    @season = colorway_line[3]
    
  end
end