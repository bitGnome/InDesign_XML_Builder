class SizeRange
  
  def catalog_format(sizeRange)
    
    @sizeRange = sizeRange
    
    if sizeRange.nil?
      @sizeRange = "NONE"
    else
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
    end
    
    #puts "Size Range for  sizeRange: " + @sizeRange
    return @sizeRange
    
  end
  
  def workbook_format(size_range)
    
    @sizeRange = size_range
    
    sizeRangeSplit = @sizeRange.split(', ')
    
    unless size_range.match(/^[\d]+/)
      @sizeRange = sizeRangeSplit.first + "-" + sizeRangeSplit.last
    end
    
    return @sizeRange
    
  end
  
  def joker_format(size_range)
    
    size_range_split = size_range.split(', ')
    return size_range_split
    
  end
  
  def to_s
    @sizeRange
  end
  
end