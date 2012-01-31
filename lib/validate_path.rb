class ValidatePath
  
  attr_reader :path
  
  def initialize(_path)
    
    @path = _path
    begin
      testPath = File.new(@path)
    rescue
      puts ("Cannot connect to path with assets: #{@path}! EXITING SCRIPT!")
      exit()
    end
    
  end
end