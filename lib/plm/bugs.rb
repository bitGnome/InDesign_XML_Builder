class Bugs

  def initialize(bugs)
    
    @bugs = bugs
    
  end
  
  def getBugInfo
    
    @bugInfo = ""
    
    # Since not all bugs have just yes/no attributes this case statement addresses
    # all the current cases for catalog
    @bugInfo += "NEW " if @bugs[:status] == "New"
    @bugInfo += "eFiber " if @bugs[:eFiber] == "Yes"
    @bugInfo += "polartec " if @bugs[:polartec] == "Yes"
    @bugInfo += "bluesign " if @bugs[:bluesign] == "Yes"
    @bugInfo += @bugs[:upf] if @bugs[:upf] != nil
       
    return @bugInfo
  
  end
end