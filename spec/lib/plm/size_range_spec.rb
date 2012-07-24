require_relative '../../../lib/plm/size_range'

describe SizeRange do
  
  it "should return the size range S-XL" do
    S_XL = "S, M, L, XL"
    size_range = SizeRange.new
    size_range.catalog_format(S_XL).should eq("S-XL")
 end
 
 it "should return the size range 28-40/even + 29, 31, 33" do
   PANT_SIZES = "28, 29, 30, 31, 32, 33, 34, 36, 38, 40"
   size_range = SizeRange.new
   size_range.catalog_format(PANT_SIZES).should eq("28-40/even + 29, 31, 33")
 end
  
end