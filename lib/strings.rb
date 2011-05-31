class String
  
  def titleCase
     
      words = self.scan(/[\w']+/)
      newString = String.new
      
      words.each do |word|
        newString += word.capitalize +  " "
      end
      
      #chomp(newString)
      return newString
      
  end

end