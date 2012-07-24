class ColorwayParse
  
  require 'csv'
  require_relative 'colorway'
  require_relative '../utils/import_csv'
  require_relative "../utils/strings"
  
  attr_reader :colorways
  
  VALID_HEADERS = ["Color Numeric", "3-Letter Alpha Code", "Description"]
  
  def initialize(colorway_data_file)
    
    colorway_hash = ImportCsv.new(colorway_data_file)
    
    invalid_header = colorway_hash.verify_headers(VALID_HEADERS)
    
    raise "Colorway CSV has the following invalid headers #{invalid_header}" if invalid_header.count > 0
    
    @colorways = Hash.new
    
    #CSV.foreach(colorwayData) do | row |
     colorway_hash.data.each do |row|
      
      if row["Color Numeric"].is_a_number?
        @colorways[row["3-Letter Alpha Code"].to_s] = Colorway.new(row, VALID_HEADERS[0], VALID_HEADERS[1], VALID_HEADERS[2])
      end
      
    end
    
  end
end