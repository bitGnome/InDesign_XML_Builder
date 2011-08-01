class ParsePlm
  
  require 'csv'
  require_relative 'plm_data'
  
  attr_reader :data
  
  def initialize(dataFile, carry_in_copy_only)
    
    @data = Hash.new
    
    # Loop through the PLM data and create the plmDataHash
    CSV.foreach(dataFile) do |row|
     
      # Create a new PlmData object and store it in the plmDataHash with the styleNumber as the Key
      @data[row[1].to_s] = PlmData.new(row, carry_in_copy_only)
     
    end
  end
end