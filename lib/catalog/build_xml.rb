class BuildXml
  
  require 'builder'
  require_relative '../utils/strings'
  
  attr_reader :section
  
  def initialize(productArray, xmlFile, pageNum, colorwayInfo)
    
    @productArray = productArray
    @xmlFile = xmlFile
    @pageNum = pageNum
    @colorwayInfo = colorwayInfo
    
  end
  
  def create_catalog_xml(eu_specs)
    
    eu_specs = eu_specs
    
    xml = Builder::XmlMarkup.new(:target => @xmlFile, :indent => 0)
    xml.instruct! :xml, :version => "1.0", :encoding => "UTF-8"
    
    xml.Root do
      @productArray.each do | product |
        
        @section = product.section.downcase;
        
        xml.Product( :type  => product.type ) do
          
          if (product.plm_data.plmHash[:productName] == nil)
            productName = product.thumbnail_prodName
          else
             productName = product.plm_data.plmHash[:productName]
          end
                     
          clean_product_name = productName.remove_PLM_corruption
          product_name_encoded = clean_product_name.encode_smart_quotes
          
          xml.product_name    { |text| text << product_name_encoded }
          xml.bugs            ( product.plm_data.plmHash[:bugInfo].getBugInfo )
                    
          if product.copy_type == "latin"
            catalog_copy = product.plm_data.plmHash[:latin_copy]
          else
            catalog_copy = product.plm_data.plmHash[:productCopy]
          end
          
          clean_product_copy = catalog_copy.remove_PLM_corruption
          xml.product_copy    { |text| text << clean_product_copy.encode_smart_quotes }
          
          xml.fit             ( product.plm_data.plmHash[:fit] )
          xml.countryOfOrigin ( product.plm_data.plmHash[:countryOfOrigin] )
          xml.style_number    ( product.plm_data.plmHash[:styleNumber] )
          
          if (eu_specs)
            xml.price_eu      ( product.euro )
            xml.price_pound   ( product.pound )
            xml.size_range    ( product.eu_size_range )
            #puts ("euros : #{product.euro} / pounds : #{product.pound} / size_range : #{product.eu_size_range}")
          else
            xml.price           ( product.plm_data.plmHash[:price] )  
            xml.size_range      ( product.plm_data.plmHash[:sizeRange] )
          end
          
          xml.size_range      ( product.plm_data.plmHash[:sizeRange] )
          xml.weight_oz       ( product.plm_data.plmHash[:weight].weight_oz )
          xml.weight_g        ( product.plm_data.plmHash[:weight].weight_g )
          
          # Get all the colorway information
          product.colorways[@pageNum].each do | colorAlpha |
            
            # Pull in the colorway information if the Alpha supplied in the thumbNail does not exists set defaults
            begin
              colorNum = @colorwayInfo.colorways[colorAlpha].number
              colorName = @colorwayInfo.colorways[colorAlpha].name
            rescue
              colorNum = "XXX"
              colorName = "Not Found"
            end
            
            xml.colorway do
              xml.alpha   ( colorAlpha )
              xml.numeric ( colorNum )
              xml.name    ( colorName )
            end
          end
          
          xml.product_caption do
            
            begin
              featureColorNum = @colorwayInfo.colorways[product.feature_color].number
              featureColorName = @colorwayInfo.colorways[product.feature_color].name
            rescue
              featureColorNum = "XXX"
              featureColorName = "Not Found"
            end      
            
            product_name_no_reg = product_name_encoded.remove_trade_reg_marks
            xml.name { |text| text << product_name_no_reg.truncate_gender }
            xml.colorAlpha ( product.feature_color )
            xml.colorNumber ( featureColorNum )
            xml.colorName ( featureColorName )
                 
          end
          
          xml.FPO do
            fpo_fileName = product.plm_data.plmHash[:styleNumber] + ".jpg"
            xml.file_name ( fpo_fileName )
          end
            
        end
      end
    end
     
    @xmlFile.close
    
  end
  
  def create_corp_sales_jpeg
    
    xml = Builder::XmlMarkup.new(:target => @xmlFile, :indent => 2)
    xml.instruct! :xml, :version => "1.0", :encoding => "UTF-8"
    
    xml.Root( "xmlns:aid" => "http://ns.adobe.com/AdobeInDesign/4.0/" ) do
        
      xml.product_name    ( @productArray[0].plm_data.plmHash[:productName] )
      xml.style_number    ( @productArray[0].plm_data.plmHash[:styleNumber] )
          
      # Get all the colorway information
      @productArray[0].colorways[@pageNum].each do | colorAlpha |
        
        xml.Product do
          # Pull in the colorway information if the Alpha supplied in the thumbNail does not exists set defaults
          begin
            colorNum = @colorwayInfo.colorways[colorAlpha].number
            colorName = @colorwayInfo.colorways[colorAlpha].name
          rescue
            colorNum = "XXX"
            colorName = "Not Found"
          end
              
          xml.colorway do
            xml.alpha   ( colorAlpha )
            xml.numeric ( colorNum )
            xml.name    ( colorName )
          end
              
          xml.product_image do
            fpo_fileName = "#{@productArray[0].plm_data.plmHash[:styleNumber]}_#{colorAlpha}.jpg"
            xml.file_name ( fpo_fileName )
          end
        end
      end
    end
     
    @xmlFile.close
    
  end
  

  
end