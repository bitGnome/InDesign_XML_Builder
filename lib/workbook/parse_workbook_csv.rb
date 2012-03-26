class ParseWorkbookCsv
  
  require 'csv'
  require_relative 'workbook_product'
  
  attr_reader :products
  
  def initialize(csv_data, workbook_bugs, workbook_version)
    
    @products = Hash.new
    
    csv_data = CSV.read(csv_data)
    headers = csv_data.shift.map {|i| i.to_s }
    string_data = csv_data.map {|row| row.map {|cell| cell.to_s } }
    workbook_csv = string_data.map {|row| Hash[*headers.zip(row).flatten] }
    
    # Loop through the PLM data (csv)
    workbook_csv.each do |row|
      
      style_number = row["Style Number"]
      
      #puts "processing :: #{style_number}"
      
      unless @products.has_key?(style_number)
        
        @products[style_number] = WorkbookProduct.new(row, workbook_bugs)
        @products[style_number].base_information
        
        if workbook_version.eql? "usb"
          @products[style_number].usb_information
        end
        
      end
      
      @products[style_number].insert_colorway(row)
      
    end
  end
  
end