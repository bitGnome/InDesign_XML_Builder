class BuildJokerXml
  
  require 'fileutils'
  require 'builder'
  
  def initialize(joker)
    
    @joker = joker
    
    unless Dir.exists?("./XML")
      FileUtils.mkdir './XML'
    end
    
  end
  
  def build
    
    # Set up XML -> InDesign styles
    prod_name_main_pstyle = "Product_Title_Big"
    spec_copy_pstyle = "Product_Specs"
    rise_fit_leg_pstyle = "rise_fit_leg"
    size_range_pstyle = "imprint_sizes"
    rm_pstyle = "RM"
    rm_info_pstyle = "RM_Copy"
    spine_size_pstyle = "spine_size"
    spine_prod_name_pstyle = "spine_prodName"
    spine_style_num_pstyle = "spine_styleNum"
    
    imprint_header_cstyle = "imprint_red"
    
    xml_file = File.new("XML/#{@joker.rm_number}.xml", File::CREAT|File::RDWR)
    
    xml = Builder::XmlMarkup.new(:target => xml_file, :indent => 0)
    xml.instruct! :xml, :version => "1.0", :encoding => "UTF-8"
    
    xml.Root( "xmlns:aid" => "http://ns.adobe.com/AdobeInDesign/4.0/" ) do
      
      xml_file.write("\n")
      
      xml.Product_Title("aid:pstyle" => prod_name_main_pstyle) { |product_title| product_title << @joker.product_name}
      
      xml_file.write("\n")
      
      xml.specCopy("aid:pstyle" => spec_copy_pstyle) { |spec_copy| spec_copy << @joker.spec_line }
      
      xml_file.write("\n")
      
      xml.rise_fit_leg("aid:pstyle" => rise_fit_leg_pstyle) { |text| text << @joker.rise_fit_leg.downcase }
      
      xml_file.write("\n")
      
      xml.rm("aid:pstyle" => rm_pstyle) { |rm_text| rm_text << @joker.rm_on_tag }
      
      xml_file.write("\n")
      
      xml.size_range("aid:pstyle" => size_range_pstyle) do
        xml.imprint_header("IMPRINT SIZES FOR THE STYLE", "aid:cstyle"  => imprint_header_cstyle)
        xml_file.write("\n")
        
        xml.imprint_sizes do
          @joker.size_range.each do |size|
            xml_file.write("#{size}\n")
          end
        end
      end
      
      xml_file.write("\n")
      
      xml.spine_size("aid:pstyle" => spine_size_pstyle) { |spine_size| spine_size << "size: #{@joker.display_size}" }
      xml_file.write("\n")
      
      xml.spine_prodName("aid:pstyle" => spine_prod_name_pstyle) { |spine_name| spine_name << @joker.product_name }
      xml_file.write("\n")
      
      xml.spine_styleNum(@joker.style_number, "aid:pstyle" => spine_style_num_pstyle)
      xml_file.write("\n")
      
      xml.rm_info("aid:pstyle" => rm_info_pstyle) { |rm_info| rm_info <<  @joker.rm_information }
      
      unless @joker.upf.eql?("")
        xml.upf(@joker.upf)
      end
       
    end
    
    
    xml_file.close
    
  end
  
end