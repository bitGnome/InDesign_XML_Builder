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
  
  def truncate_gender
    m_w = self.gsub(/Women's/, "W&#8217;s")
    m_w = m_w.gsub(/Women&#8217;s/, "W&#8217;s")
    m_w = m_w.gsub(/Men&#8217;s/, "M&#8217;s")
    m_w = m_w.gsub(/Men's/, "M&#8217;s")
    return m_w
  end
  
  def get_gender
        
    case self.downcase
    when /^women/
      return "women"
    when /^men/
      return "men"
    when /^boy/
      return "boy"
    when /^girl/
      return "girl"
    when /^baby/
      return "baby"
    else
      return "unisex"
    end
    
  end
  
  def remove_trade_reg_marks
    
    # Remove Registered Trademarks (R)
    clean_string = self.gsub(/\&\#174;/, '')
    
    # Remove Trade Marks (TM)
    #clean_string = clean_string.gsub(/\342\204\242/, '')
    clean_string = clean_string.gsub(/\&\#8482;/, '')
    return clean_string
    
  end
  
  def is_a_number?
    self.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true 
  end
  
  def remove_double_quotes
    clean_string = self.gsub(/\"+/, "\"")
  end

end