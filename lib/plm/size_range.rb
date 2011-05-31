class SizeRange
  
  attr_accessor :sizeRange
  
  def initialize(sizeRange)
    
    @sizeRange = sizeRange
    
    sizeRangeSplit = @sizeRange.split(', ')
    
    # Test to see if the size range has numbers in it
    if (/^[\d]+/ === @sizeRange )
      
      # If the size range is number using the following format 28-26/even + 31, 33, 35
      sizeEven = Array.new
      sizeOdd = Array.new
      
      sizeRangeSplit.each do |value|

        # Only process whole numbers and do not process kid sizes 12M or 2T .. etc
        if (value.match(/[A-Z]/) == nil && value.match(/\./) == nil)
           
           if (value.to_i%2 == 0) then sizeEven.push(value)
           else sizeOdd.push(value)
           end
           
        end
      
      end
    
        newSizeRange = sizeEven.first.to_s + "-" + sizeEven.last.to_s + "/even"
          
        newSizeRange << " + " if (sizeOdd.length > 0)
     
        # Add the odd sizes
        sizeOdd.each { |value| newSizeRange << value.to_s + ", " }
                        
        # Remove the last ", "
        @sizeRange = newSizeRange.gsub(/\,\s$/, "")
      
    else
      
      @sizeRange = sizeRangeSplit.first + "-" + sizeRangeSplit.last
      
    end
    
    #puts "Size Range for  sizeRange: " + @sizeRange
    
  end
  
  def to_s
    @sizeRange
  end
  
end