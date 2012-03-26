class Rise
  
  def initialize(rise)
    
    unless rise.nil?
      @rise_format = rise.to_s + " rise"  
    end
  
  end
  
  def to_s
    @rise_format
  end

end