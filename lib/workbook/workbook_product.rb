class WorkbookProduct
  
  require_relative '../plm/weight'
  require_relative '../plm/fit'
  require_relative '../plm/size_range'
  require_relative 'product_colorways'
  require_relative 'workbook_bugs'
  require_relative '../utils/strings'
  require_relative 'workbook_features'
  
  attr_reader :product_data, :colorways, :features
  
  def initialize(plm_data, workbook_bugs)
    
    @colorways = ProductColorways.new
    @product_data = Hash.new
    @plm_data = plm_data
    @workbook_bugs = workbook_bugs
    @features = WorkbookFeatures.new
    
  end
  
  def base_information
    if @plm_data["Marketing Name"].nil?
      @product_data[:product_name] = "product name"
    else
      product_name = @plm_data["Marketing Name"].truncate_gender
      @product_data[:product_name] = product_name
    end
    
    @product_data[:style_number] = @plm_data["Style Number"]
    
    if @plm_data["Workbook Overview"].nil?
      @product_data[:overview] = "No overview supplied in the PLM!"
    else
      @product_data[:overview] = @plm_data["Workbook Overview"]
    end
    
    @product_data[:status] = @workbook_bugs.status(@plm_data["Status"].downcase)
    fit = Fit.new(@plm_data["Fit"])
    @product_data[:fit] = fit.to_s
    
    size_range = SizeRange.new
    @product_data[:size_range] = size_range.workbook_format(@plm_data["Size Range"])
    
    weight = Weight.new(@plm_data["Weight in Oz."].to_f)
    @product_data[:weight_oz] = weight.weight_oz
    @product_data[:weight_g] = weight.weight_g
    
    volume = @plm_data["Volume (Liters)"].to_f
    if (volume > 0)
      @product_data[:size_range] = "#{volume.round} L"
    end
    
    @product_data[:polartec] = @workbook_bugs.boolean("polartec", @plm_data["Polartec Product"])
    @product_data[:e_style] = @workbook_bugs.boolean("e_style", @plm_data["E Style"])
    @product_data[:upf] = @workbook_bugs.upf(@plm_data["UPF Value"])
    @product_data[:gore_tex] = @workbook_bugs.gore_tex(@plm_data["Gore-Tex Primary"])
    @product_data[:h2no] = @workbook_bugs.h2no(@plm_data["H2No"])
    @product_data[:inseam] = @plm_data["Inseam"]
    
    @product_data[:bluesign] = @workbook_bugs.bluesign(@plm_data["Bluesign Approved"])
    @product_data[:insulation] = @workbook_bugs.insulation(@plm_data["Insulation"])
    @product_data[:rise] = @plm_data["Rise"]
    @product_data[:regulator] = @workbook_bugs.boolean("regulator", @plm_data["Regulator Product"])
    @product_data[:leg_silhouette] = @plm_data["Leg Silhouette"]
    @product_data[:inseam_zipoff] = @plm_data["Inseam - Zip-Off Shorts"]
   
  end
  
  def usb_information
    
    if @plm_data["Delivery Date (Ex-DC)"].nil?
      @product_data[:delivery_date] = "0/0/0"
    else
      @product_data[:delivery_date] = @plm_data["Delivery Date (Ex-DC)"]
    end
    
    if @plm_data["Material Description (Edit)"].nil?
      @product_data[:material_desc] = "No Material Description in PLM!"
    else
      @product_data[:material_desc] = @plm_data["Material Description (Edit)"]
    end
    
    @features.add_feature(@plm_data["Workbook Feature 1"], @plm_data["Workbook Feature 1 - Revised"])
    @features.add_feature(@plm_data["Workbook Feature 2"], @plm_data["Workbook Feature 2 - Revised"])
    @features.add_feature(@plm_data["Workbook Feature 3"], @plm_data["Workbook Feature 3 - Revised"])
    @features.add_feature(@plm_data["Workbook Feature 4"], @plm_data["Workbook Feature 4 - Revised"])
    @features.add_feature(@plm_data["Workbook Feature 5"], @plm_data["Workbook Feature 5 - Revised"])
    @features.add_feature(@plm_data["Workbook Feature 6"], @plm_data["Workbook Feature 6 - Revised"])
    @features.add_feature(@plm_data["Workbook Feature 7"], @plm_data["Workbook Feature 7 - Revised"])
        
  end
  
  def insert_colorway(plm_color_data)
    
    name = plm_color_data["Color Placement 1"]
    alpha = plm_color_data["AS400 Default Colorway Alpha Label"]
    number = plm_color_data["Color Numeric"]
    
    @colorways.insert_colorway(name, alpha, number)
  end
end