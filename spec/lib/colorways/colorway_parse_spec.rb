require_relative '../../../lib/colorways/colorway_parse'

describe ColorwayParse do
  
  it "should raise an exception when a CSV file has invalid headers" do
    colorway_file = File.join([File.dirname(__FILE__), "../../fixtures/colorways_invalid_headers.csv" ])
    colorway_data = File.new(colorway_file, "r")
    lambda { ColorwayParse.new(colorway_file) }.should raise_exception(RuntimeError, 'Colorway CSV has the following invalid headers ["Color Num", "3-Letter", "Yo"]')
  end
  
  it "should return 4 colorways" do
    colorway_file = File.join([File.dirname(__FILE__), "../../fixtures/colorways.csv" ])
    colorway_data = File.new(colorway_file, "r")
    colorway_file = ColorwayParse.new(colorway_file)
    colorway_file.colorways.count.should eq(4)
  end
  
  it "should return the nuber 007 for alpha code LOK" do
    colorway_file = File.join([File.dirname(__FILE__), "../../fixtures/colorways.csv" ])
    colorway_data = File.new(colorway_file, "r")
    colorway_file = ColorwayParse.new(colorway_file)
    colorway_file.colorways["LOK"].number.should eq("007")
  end
  
end
