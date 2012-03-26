class JokerTemplateBuilder
  
  require 'fileutils'
  
  def initialize(joker)
    
    # Check and make sure there are 4 templates located in the Templates folder
    unless FileTest.exist?("./Templates/short.indd")
      puts "Cannot find the short template (./Templates/short.indd) ... EXITING!"
      exit
    end
    
     # Check and make sure there are 4 templates located in the Templates folder
    unless FileTest.exist?("./Templates/short_e.indd")
      puts "Cannot find the short e-fiber template (./Templates/short_e.indd) ... EXITING!"
      exit
    end
    
     # Check and make sure there are 4 templates located in the Templates folder
    unless FileTest.exist?("./Templates/long.indd")
      puts "Cannot find the long template (./Templates/long.indd) ... EXITING!"
      exit
    end
    
     # Check and make sure there are 4 templates located in the Templates folder
    unless FileTest.exist?("./Templates/long_e.indd")
      puts "Cannot find the long e-fiber template (./Templates/long_e.indd) ... EXITING!"
      exit
    end
    
    unless Dir.exists?("./Jokers")
      FileUtils.mkdir './Jokers'
    end
    
    if joker.upf.eql?("")
      if joker.e_style.downcase.eql?("no")
        template_file = "./Templates/short.indd"
        
      else
        template_file = "./Templates/short_e.indd"
      end
    else
      if joker.e_style.downcase.eql?("no")
        template_file = "./Templates/long.indd"
      else
        template_file = "./Templates/long_e.indd"
      end    
    end
    
    FileUtils.cp(template_file, "Jokers/#{joker.rm_number}.indd")
    
  end
end