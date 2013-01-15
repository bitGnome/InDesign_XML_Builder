class Bugs

  def initialize(bugs)
    
    @bugs = bugs
    
  end
  
  def getBugInfo
    
    @bugInfo = ""
    
    # Set up bugInfo
    @bugInfo += "NEW " if @bugs[:status] == "New"
    @bugInfo += "eFiber " if @bugs[:eFiber] == "Yes"
    @bugInfo += "polartec " if @bugs[:polartec] == "Yes"
    @bugInfo += "bluesign " if @bugs[:bluesign] == "Fabric"
    @bugInfo += @bugs[:upf] if @bugs[:upf] != nil 
       
    return @bugInfo
  
  end
end