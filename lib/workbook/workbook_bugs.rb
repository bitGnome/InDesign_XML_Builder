class WorkbookBugs
  
  attr_accessor :path
  
  def initialize
    @path = Hash.new
  end
  
  def boolean(name, value)
    
    value = test_for_nil(value)
    
    value.downcase!
    
    if value == "yes"
      return @path[name.to_sym]
    else
      return nil
    end
  end
  
  def status(value)
    
    value = test_for_nil(value)
    
    value.downcase!
    if value == "new"
      return @path[:new]
    elsif value == "redesign"
      return @path[:rev]
    end
  end
  
  def upf(value)
    
    value = test_for_nil(value)
    
    value.downcase!
    case
    when value.match(/50\+/)
      return @path[:upf_50_plus]
    when value.match(/50/)
      return @path[:upf_50]
    when value.match(/40/)
      return @path[:upf_40]
    when value.match(/35/)
      return @path[:upf_35]
    when value.match(/30/)
      return @path[:upf_30]
    when value.match(/25/)
      return @path[:upf_25]
    when value.match(/20/)
      return @path[:upf_20]
    when value.match(/15/)
      return@path[:upf_15]
    else
      return nil
    end
    
  end
  
  def gore_tex(value)
    
   value = test_for_nil(value)
    
    value.downcase!
         
    case 
    when value.match(/product/)
      return @path[:gore_tex]
    when value.match(/windstopper/)
      return @path[:windstopper]
    else
      return nil
    end
    
  end
  
  def h2no(value)
    
    value = test_for_nil(value)
    
    value.downcase!
    if value.match(/h2no/)
      return @path[:h2no]
    else
      return nil
    end
  end
  
  def bluesign(value)
    
    value = test_for_nil(value)
    
    value.downcase!
    if value == "no"
      return nil
    else
      return @path[:bluesign]
    end
  end
  
  def insulation(value)
    
    value = test_for_nil(value)
    
    value.downcase!
    if value.match(/primaloft/)
      return @path[:prima_loft]
    else
      return nil
    end
  end
  
  def test_for_nil(value)
    if value.nil?
      return "nil"
    else
      return value
    end
  end
    
end