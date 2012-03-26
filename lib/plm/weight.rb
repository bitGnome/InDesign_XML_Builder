class Weight
  
  attr_accessor :weight_oz, :weight_g
  
  def initialize(weight_oz)
    
    @weight_g = (weight_oz * 28.3495231).round
    @weight_oz = weight_oz == weight_oz.to_i ? weight_oz.to_i : weight_oz
    
  end
  
  def grams
    @weight_g
  end
  
  def ounces
    @weight_oz
  end
  
end