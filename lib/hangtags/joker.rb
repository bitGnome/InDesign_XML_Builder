class Joker
  
  require_relative '../plm/size_range'
  require_relative '../utils/strings'
  require_relative '../plm/rise'
  require_relative '../plm/fit'
  
  attr_reader :product_name, :style_number, :spec_line, :size_range, :display_size, :rise_fit_leg 
  attr_reader :rm_on_tag, :rm_number, :rm_information, :upf, :e_style
  
  def initialize(data)
    
    @womens_sizes = Hash.new
    @womens_sizes['24'] = "00"
    @womens_sizes['25'] = "0"
    @womens_sizes['26'] = "2"
    @womens_sizes['27'] = "4"
    @womens_sizes['28'] = "6"
    @womens_sizes['29'] = "8"
    @womens_sizes['30'] = "10"
    @womens_sizes['31'] = "12"
    @womens_sizes['32'] = "14"
    
    @product_name = data["Marketing Name"].remove_double_quotes
    @product_name = @product_name.encode_smart_quotes
    @gender = @product_name.get_gender
    
    @style_number = data["Style Number"]

    sizes = SizeRange.new
    size_array = sizes.joker_format(data["Size Range"])
    size_range_format = format_sizes(size_array, @gender)
    @size_range = size_range_format
    @display_size = @size_range[0]
    
    @rise_fit_leg = format_rise_fit_leg(data["Rise"], data["Fit"], data["Leg Silhouette"])
    
    @inseam = data["Inseam"]
    @inseam_zipoff = data["Inseam - Zip-Off Shorts"]
    #@spec_line = format_spec_line(@display_size, @inseam, @inseam_zipoff)
    
    format_tag(data["Hangtag/Package"])
    
    @rm_information = data["Hangtag RM #1"]
    rm_split = @rm_information.split("\s")
    @rm_number = rm_split[0]
    @rm_on_tag = format_rm(@rm_number)
    
    @upf = data["UPF Value"]
    @e_style = data["E Style"]
    
  end
  
  def format_spec_line(size, inseam, inseam_type)
    
    spec_line_text = "size: " + size
    
    ## Still need to address what to do about zip-off inseam
    unless inseam.eql?("")
      if inseam_type.eql?("pants")
        spec_line_text += "&#8195;inseam: " + inseam + "\""
      elsif inseam_type.eql?("shorts")
        spec_line_text += "&#8195;short inseam: " + inseam + "\""
      end
    end
    
    return spec_line_text
    
  end
  
  def format_sizes(size_range, gender)
    
    format_size_range = Array.new
    
    size_range.each do |size|
      # Do not add inch marks to womens sizes 0 - 14
      if size.is_a_number? && size.to_f > 20
        
        size_string = size +"\""
        
        if gender.eql?("women")
          size_string += " (#{@womens_sizes[size]})"
        end
        
        format_size_range << size_string
        
      else
        format_size_range << size
      end
    end
    
    return format_size_range
    
  end
  
  def format_rise_fit_leg(rise, fit, leg)
    
    rise_fit_leg_text = String.new
    
    unless rise.eql?("")
      rise_format = Rise.new(rise)
      rise_fit_leg_text = rise_format.to_s + "&#8195;"
    end
    
    unless fit.eql?("")
      fit_format = Fit.new(fit)
      rise_fit_leg_text += fit_format.to_s+ "&#8195;"
    end
    
    unless leg.eql?("")
      rise_fit_leg_text += leg 
    end
    
    rise_fit_leg_text.gsub!(/\&#8195\;$/, "")
    return rise_fit_leg_text.strip
     
  end
  
  def format_tag(hangtag_package)
    
    ht_pkg_split = hangtag_package.split("|")
    tag_type = ht_pkg_split[1]
    
    case tag_type.upcase
    #puts "M's 1-length, Open & 32"
    when "A"
      @spec_line = format_spec_line(@display_size, @inseam, "pants")
      
    # M's 3-length :: Pants(B), Cords(C) and Jeans(D).
    when "B", "C", "D"
      
      product_name_split = @product_name.split("-")
      product_name_root = product_name_split[0].strip
      @product_name = product_name_root
      
      unless product_name_split[1].nil? 
        
        product_length = product_name_split[1].strip
        
        case product_length.downcase
        when "short"
          @product_name = product_name_root + " - Short"
        when "long"
          @product_name = product_name_root + " - Long"
        else
          @product_name = product_name_root
        end        
        
      end

      @display_size += " x " + @inseam + "\""
      @spec_line = format_spec_line(@display_size, @inseam, "no_inseam")
      
    # M's shorts and board shorts
    when "E"
      @spec_line = format_spec_line(@display_size, @inseam, "pants")
      
    # M's Zip-Off Pants
    when "F"
      
      product_name_split = @product_name.split("-")
      product_name_root = product_name_split[0].strip
      product_length = product_name_split[1].strip
      @product_name = product_name_root + " - " + product_length
      
      @spec_line = format_spec_line(@display_size, @inseam_zipoff, "shorts")
      
    # W's 1-length, Open
    when "G"
      @spec_line = format_spec_line(@display_size, @inseam, "pants")
    
    # W's 3-lengths
    when "H"
      @spec_line = format_spec_line(@display_size, @inseam, "pants")
    
    # W's Denium and Cords
    when "I"
      @spec_line = format_spec_line(@display_size, @inseam, "pants")
      
    # W's Shorts and Board Shorts
    when "J"
      @spec_line = format_spec_line(@display_size, @inseam, "pants")
    
    # W's Skirts
    when "K"
      @spec_line = format_spec_line(@display_size, @inseam, "pants")
    
    # W's Zip-Off Pants 
    when "L"
      @spec_line = format_spec_line(@display_size, @inseam_zipoff, "shorts")
      
    else
      puts "Tag type not found for #{@product_name} = #{@style_number}"
    end
    
  end
  
  def format_rm(rm_number)
    
    #Current Format for the RM number on the tag as follows
    # ###<BOLD Style Number>##
    
    rm_format = String.new
    
    rm_numbers = rm_number.split(//)
    
    (0..4).each { |index| rm_format += rm_numbers[index] }
    
    rm_format += "<rm_bold aid:cstyle=\"RM_Bold\">"
    (5..9).each { |index| rm_format += rm_numbers[index]}
    rm_format += "</rm_bold>"
    
    return rm_format
    
  end

end