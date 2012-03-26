class ParsePlm
  
  require 'csv'
  require_relative 'plm_data'
  
  attr_reader :data
  
  def initialize(dataFile, copy_option)
    
    @data = Hash.new
    @copy_option = copy_option
    
    csv_data = CSV.read(dataFile)
    headers = csv_data.shift.map {|i| i.to_s }
    string_data = csv_data.map {|row| row.map {|cell| cell.to_s } }
    plm_data = string_data.map {|row| Hash[*headers.zip(row).flatten] }    
    
    # Loop through the PLM data and create the plmDataHash
    plm_data.each do |row|
     
      # Create a new PlmData object and store it in the plmDataHash with the styleNumber as the Key
      @data[row["Style Number"].to_s] = PlmData.new(row, @copy_option)
     
    end
  end
end