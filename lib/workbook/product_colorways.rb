class ProductColorways
  
  attr_reader :name, :number
  
  def initialize()
    
    @name = Hash.new
    @number = Hash.new
    
  end
  
  def insert_colorway(name, alpha, number)
    
    if number.nil?
      number = "##_#{alpha}_##"
    else
      number = sprintf "%03d", number
    end
    
    @name[alpha] = name
    @number[alpha] = number
    
  end
end