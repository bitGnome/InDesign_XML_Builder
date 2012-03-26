class JokerCsvParse
  
  require 'csv'
  
  
  attr_reader :jokers
  
  def initialize(data_file)
    
    @jokers = Array.new
    
    csv_data = CSV.read(data_file)
    headers = csv_data.shift.map {|i| i.to_s }
    string_data = csv_data.map {|row| row.map {|cell| cell.to_s } }
    data = string_data.map {|row| Hash[*headers.zip(row).flatten] }
    
    # Only pull in jokers from the CSV file
    data.each do |row|
      if row["Joker Tag - New Art?"].downcase.eql?("yes") then @jokers << row end
    end
       
  end
    
end