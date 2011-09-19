class String
  
  def titleCase
     
      words = self.scan(/[\w']+/)
      newString = String.new
      
      words.each do | word |
        newString += word.capitalize +  " "
      end
      
      newString = newString.strip
      return newString
      
  end
  
  def remove_PLM_corruption
    
    # \023 should be an en dash. But it is getting corrupted by the PLM
    clean_string = self.gsub(/\023/, "&#8211;")
    
    # \031 should be a ' dash. But it is getting corrupted by the PLM
    clean_string = clean_string.gsub(/\031/, "&#8217;")
    
    # \035 should be a double grave mark (or what Edit calls the "inch mark"). But it is getting corrupted by the PLM
    clean_string = clean_string.gsub(/\035/, "&#733;")
    
     # \024 Not sure what this should be?? Replacing it with a <space> 
    clean_string = clean_string.gsub(/\024/, " ")
    
  end
  
  def encode_smart_quotes
    
    # A bit of a hack but this is the best that I can come up with at this time.
    begining_double_smart_quotes_replace = self.gsub(/([\s]\")/, " &#8220;")
    end_double_smart_quotes_replace = begining_double_smart_quotes_replace.gsub(/(\"[\s])/, "&#8221; ")
    apostrophe_replace = end_double_smart_quotes_replace.gsub(/([\S]\'[\S])/) {|chars| chars[0] + '&#8217;' + chars[2]}
    begining_single_smart_quotes_replace = apostrophe_replace.gsub(/([\s]\')/, " &#8216;")
    end_single_smart_quotes_replace = begining_single_smart_quotes_replace.gsub(/(\"[\s])/, "&#8217; ")
  
  end

end