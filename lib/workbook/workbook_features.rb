class WorkbookFeatures
  
  attr_reader :list
  
  def initialize
    @list = Array.new
  end
  
  def add_feature(feature_text, feature_status)
    
    unless ( feature_text.eql?("") || feature_text == "." )
      
      feature_data = Hash.new
      
      feature_data[:text] = feature_text
      
      if ( feature_status.nil? )
        feature_data[:revised] = "no"
      else
        feature_data[:revised] = feature_status.downcase
      end
      
      @list << feature_data
      
    end
    
  end
  
end