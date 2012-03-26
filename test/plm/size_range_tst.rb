#!/usr/bin/env ruby

require_relative '../../lib/plm/size_range'
require 'test/unit'

class TestSizeRange < MiniTest::Unit::TestCase
  
  S_XL = "s, m, l, xl"
  PANT_SIZES = "28, 29, 30, 31, 32, 33, 34, 36, 38, 40"
  
  def size_range_format
   
   size_range = SizeRange.new
   size_range_format = size_range.catalog_format(S_XL)
   assert_equal("s-xl", size_range_format)
   
   size_range_format = size_range.catalog_format(PANT_SIZES)
   assert_eual("28-40/even + 29, 31, 33", size_range_format)
    
  end
end
