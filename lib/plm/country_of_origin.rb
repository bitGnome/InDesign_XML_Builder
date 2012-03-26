class CountryOfOrigin

  require_relative '../utils/strings' 
  
  @capOrigin 
  
  def initialize(countryOfOrigin)
    
    if countryOfOrigin == nil then 
    
      @capOrgin = "NO COUNTRY OF ORIGIN" 
    
    else
     
      @capOrgin = "Made in "
      countryOfOrgin_string = countryOfOrigin.to_s
      
      # Format U. S. A to just USA
      if countryOfOrgin_string =~ /U\./
        
        # split on the ". "
        usaSplit = countryOfOrgin_string.split(". ")
        
        usaSplit.each do |letter|
          @capOrgin += letter
        end
        
        # Remove the last "." at the end of USA
        @capOrgin = @capOrgin.sub(/\./, "")
      
      else 
        
        capTitleCase = countryOfOrgin_string.titleCase
        @capOrgin += capTitleCase
        
      end    
    end
    
  end
  
  def to_s
    @capOrgin
  end

end