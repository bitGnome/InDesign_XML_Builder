class WorkbookXml
  
  require 'builder'
  require_relative '../utils/strings'
  
  def initialize(products, xml_file)
    
    @products = products
    @xml_file = xml_file
    
  end
  
  def illustration_base_path=(path)
    @illustration_base_path = path
  end
  
  def build_LAG(show_fabric_info)
    
    # Paragraph styles
    product_head = "Product Head"
    overview = "Overview"
    spec_line = "Spec_Line"
    colorways = "Colorways"
    
    #Character styles
    product_number = "Product Number"
    pipe = "Pipe"
    fit = "Fit"
    size_range = "Size Range"
    weight = "Weight"
    rise = "Rise"
    leg_sil = "Leg Silhouette"
    fabric_sizes_bold = "Fabric_Sizes_Bold"
    
    xml = Builder::XmlMarkup.new(:target => @xml_file, :indent => 0)
    xml.instruct! :xml, :version => "1.0", :encoding => "UTF-8"
    
    xml.Root( "xmlns:aid" => "http://ns.adobe.com/AdobeInDesign/4.0/" ) do
      @products.each do | style_number, product |
        xml.tag!("Prod_#{style_number}") do
          
          xml.Product_Text do
            xml.Product_Head("aid:pstyle" => product_head) { 
              |prod_head| prod_head << product.product_data[:product_name]  
              
                          unless product.product_data[:status].nil?
                            prod_head << "&#09;"
                            prod_head.bug("href"  => product.product_data[:status] )
                          end
                          
                          prod_head << "&#13;"
            }
            
            xml.Spec_Line("aid:pstyle" => spec_line) {
              |spec_line| spec_line.style_number( product.product_data[:style_number], "aid:cstyle"  => product_number )
              
                          spec_line.pipe("aid:cstyle"  => pipe ) {
                            |pipe| pipe << "&#8194;|&#8194;"
                          }
                          
                          unless product.product_data[:fit].match(/NO/)
                            spec_line.fit(product.product_data[:fit], "aid:cstyle"  => fit)
                            
                            spec_line.pipe("aid:cstyle"  => pipe ) {
                              |pipe| pipe << "&#8194;|&#8194;"
                            }
                          
                          end
                          
                          spec_line.weight( "#{product.product_data[:weight_g]} g (#{product.product_data[:weight_oz]} oz)", "aid:cstyle"  => weight )
                          
                          spec_line.pipe("aid:cstyle"  => pipe ) {
                            |pipe| pipe << "&#8194;|&#8194;"
                          }
                          
                          spec_line.size_range( product.product_data[:size_range], "aid:cstyle"  => size_range )
                          
                          unless product.product_data[:rise].nil? || product.product_data[:rise].eql?("")
                            
                            spec_line.pipe("aid:cstyle"  => pipe ) {
                              |pipe| pipe << "&#8194;|&#8194;"
                            }
                            
                            spec_line.rise(product.product_data[:rise], "aid:cstyle"  => rise )
                          
                          end
                          
                          unless product.product_data[:leg_silhouette].nil? || product.product_data[:leg_silhouette].eql?("")
                            
                            spec_line.pipe("aid:cstyle"  => pipe ) {
                              |pipe| pipe << "&#8194;|&#8194;"
                            }
                              
                            spec_line.leg_sil(product.product_data[:leg_silhouette], "aid:cstyle"  => leg_sil )
                            
                          end
                          
                          spec_line << "&#13;"
                          
            }
            
            xml.Overview("aid:pstyle"  => overview) {
              |overview|  unless product.product_data[:e_style].nil?
                            overview.bug("href"  => product.product_data[:e_style] )
                            overview.text! " "
                          end
                          
                          unless product.product_data[:polartec].nil?
                            overview.bug("href"  => product.product_data[:polartec] )
                            overview.text! " "
                          end
                          
                          unless product.product_data[:regulator].nil?
                            overview.bug("href"  => product.product_data[:regulator] )
                            overview.text! " "
                          end
                          
                          unless product.product_data[:primaloft].nil?
                            overview.bug("href"  => product.product_data[:gore_tex] )
                            overview.text! " "
                          end
                          
                          unless product.product_data[:gore_tex].nil?
                            overview.bug("href"  => product.product_data[:gore_tex] )
                            overview.text! " "
                          end
                          
                          unless product.product_data[:h2no].nil?
                            overview.bug("href"  => product.product_data[:h2no] )
                            overview.text! " "
                          end
                          
                          unless product.product_data[:bluesign].nil?
                            overview.bug("href"  => product.product_data[:bluesign] )
                            overview.text! " "
                          end
                          
                          unless product.product_data[:upf].nil?
                            overview.bug("href"  => product.product_data[:upf] )
                            overview.text! " "
                          end

                          overview.text! product.product_data[:overview]
                          
                          if show_fabric_info.eql?("y")
                            
                            overview << "&#13;"
                            
                            overview.fabric_header("aid:cstyle"  => fabric_sizes_bold ) {
                              |fabric_text| fabric_text << "FABRIC: "
                            }

                            overview.fabric_text(product.product_data[:material_desc])

                          end
            }
            
          end
          
          @xml_file.write("\n")
          
          xml.Colorwrays("aid:pstyle"  => colorways) do
            product.colorways.number.each do |alpha, number|
              xml.tag!(alpha) {
                |node|  node.alpha( alpha )
                        node.number ( " (#{number})" )
                        node << "&#13;"
                        node.name( product.colorways.name[alpha] )
              }
            end           
          end
          
          @xml_file.write("\n")
          
          xml.illustration(:href  => "#{@illustration_base_path}/#{style_number}.ai")
          
        end
      end
    end
    
    @xml_file.close
    
  end
  
  def build_USB
    # Paragraph styles
    product_head = "Product Head"
    overview = "Overview"
    spec_line = "Spec_Line"
    colorways = "Colorways"
    feature_head = "Feature_Head"
    features = "Features"
    
    #Character styles
    product_number = "Product Number"
    pipe = "Pipe"
    fit = "Fit"
    size_range = "Size Range"
    weight = "Weight"
    rise = "Rise"
    leg_sil = "Leg Silhouette"
    fabric_style = "Fabric_Sizes_Bold"
    feature_revised = "feature_revised"
    
    xml = Builder::XmlMarkup.new(:target => @xml_file, :indent => 0)
    xml.instruct! :xml, :version => "1.0", :encoding => "UTF-8"
    
    xml.Root( "xmlns:aid" => "http://ns.adobe.com/AdobeInDesign/4.0/" ) do
      @products.each do | style_number, product |
        xml.tag!("Prod_#{style_number}") do
          
          xml.Product_Text do
            xml.Product_Head("aid:pstyle" => product_head) { 
              |prod_head| prod_head << product.product_data[:product_name]  
                
                          unless product.product_data[:status].nil?
                            prod_head << "&#09;"
                            prod_head.bug("href"  => product.product_data[:status])
                          end
                          
                          prod_head << "&#13;"
            }
            
            xml.Spec_Line("aid:pstyle" => spec_line) {
              |spec_line| spec_line.style_number( product.product_data[:style_number], "aid:cstyle"  => product_number )
              
                          spec_line.pipe("aid:cstyle"  => pipe ) {
                            |pipe| pipe << "&#8194;|&#8194;"
                          }
                          
                          unless product.product_data[:fit].match(/NO/)
                            spec_line.fit(product.product_data[:fit], "aid:cstyle"  => fit)
                            
                            spec_line.pipe("aid:cstyle"  => pipe ) {
                              |pipe| pipe << "&#8194;|&#8194;"
                            }
                          
                          end
                          
                          spec_line.weight( "#{product.product_data[:weight_g]} g (#{product.product_data[:weight_oz]} oz)", "aid:cstyle"  => weight )
                          
                          spec_line.pipe("aid:cstyle"  => pipe ) {
                            |pipe| pipe << "&#8194;|&#8194;"
                          }
                          
                          spec_line.size_range( product.product_data[:size_range], "aid:cstyle"  => size_range )
                          
                          unless product.product_data[:rise].nil? || product.product_data[:rise].eql?("")
                            
                            spec_line.pipe("aid:cstyle"  => pipe ) {
                              |pipe| pipe << "&#8194;|&#8194;"
                            }
                            
                            spec_line.rise(product.product_data[:rise], "aid:cstyle"  => rise )
                          
                          end
                          
                          unless product.product_data[:leg_silhouette].nil? || product.product_data[:leg_silhouette].eql?("")
                            
                            spec_line.pipe("aid:cstyle"  => pipe ) {
                              |pipe| pipe << "&#8194;|&#8194;"
                            }
                              
                            spec_line.leg_sil(product.product_data[:leg_silhouette], "aid:cstyle"  => leg_sil )
                            
                          end
                          
                          spec_line << "&#13;"
                          
            }
            
            xml.Overview("aid:pstyle"  => overview) {
              |overview|  unless product.product_data[:e_style].nil?
                            overview.bug("href"  => product.product_data[:e_style] )
                            overview.text! " "
                          end
                          
                          unless product.product_data[:polartec].nil?
                            overview.bug("href"  => product.product_data[:polartec] )
                            overview.text! " "
                          end
                          
                          unless product.product_data[:regulator].nil?
                            overview.bug("href"  => product.product_data[:regulator] )
                            overview.text! " "
                          end
                          
                          unless product.product_data[:primaloft].nil?
                            overview.bug("href"  => product.product_data[:gore_tex] )
                            overview.text! " "
                          end
                          
                          unless product.product_data[:gore_tex].nil?
                            overview.bug("href"  => product.product_data[:gore_tex] )
                            overview.text! " "
                          end
                          
                          unless product.product_data[:h2no].nil?
                            overview.bug("href"  => product.product_data[:h2no] )
                            overview.text! " "
                          end
                          
                          unless product.product_data[:bluesign].nil?
                            overview.bug("href"  => product.product_data[:bluesign] )
                            overview.text! " "
                          end
                          
                          unless product.product_data[:upf].nil?
                            overview.bug("href"  => product.product_data[:upf] )
                            overview.text! " "
                          end

                          overview.text! product.product_data[:overview]
                          overview.text! ". "
                          
                          overview.Fabric {
                            |fabric|  fabric.heading("fabric: ", "aid:cstyle"  => fabric_style)
                                      fabric.text! product.product_data[:material_desc]
                                      fabric << "&#13;"
                          }
            }
            
            xml.Feature_Head("aid:pstyle"  => feature_head) {
              |feature_head|  feature_head.text! "features"
                              feature_head << "&#13;"
            }
            
            feature_list_count = 1
            
            xml.Feature_List("aid:pstyle"  => features) {
              
              |feature_list|  product.features.list.each do |feature|
                
                                if feature[:revised].eql? "yes"
                                  feature_list.feature(feature[:text], "aid:cstyle"  => feature_revised )
                                else
                                  feature_list.feature(feature[:text])
                                end
                                
                                unless (feature_list_count == product.features.list.length)
                                  feature_list << "&#13;"
                                end
                                
                                feature_list_count += 1
                                
                              end
            }
            
          end
          
          @xml_file.write("\n")
          
          xml.Colorwrays("aid:pstyle"  => colorways) do
            
            product.colorways.number.each do |alpha, number|
              xml.tag!(alpha) {
                |node|  node.alpha( alpha )
                        node.number ( " (#{number})" )
                        node << "&#13;"
              }
            end           
          end
          
          @xml_file.write("\n")
          
          xml.illustration(:href  => "#{@illustration_base_path}/#{style_number}.ai")
          
        end
      end
    end
    
    @xml_file.close
  end
  
  
end