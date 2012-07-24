class Fit
  
  @fit_format
  
  def initialize(fit)
    
    if fit.nil? || fit.eql?("")
       @fit_format = "NO FIT INFO" 
    else 
      # Format the fit verbage
      if fit.to_s !~ /fit/
        @fit_format = fit.to_s + " fit"
      else
        @fit_format = fit.to_s
      end  
    end
  
  end
  
  def to_s
    @fit_format
  end

end