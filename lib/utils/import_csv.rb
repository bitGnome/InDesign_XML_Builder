class ImportCsv
  
  require 'csv'
  
  attr_reader :data
  
  def initialize(csv_file)
    csv_raw_data = CSV.read(csv_file)
    @headers = csv_raw_data.shift.map { |i| i.to_s }
    string_data = csv_raw_data.map { |row| row.map {|cell| cell.to_s} }
    @data = string_data.map { |row| Hash[*@headers.zip(row).flatten] }
  end
  
  def verify_headers(valid_headers)
  
    invalid_headers = Array.new
    
    @headers.each do |header|
      unless valid_headers.include?(header)
        invalid_headers << header
      end
    end  
  
    return invalid_headers
      
  end
  
end