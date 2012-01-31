#!/usr/bin/env ruby

require_relative 'lib/catalog_fpo'

print "style_num_alpha: "
style_num_alpha = gets.upcase
style_num_alpha = style_num_alpha.chomp

print "style_num_num: "
style_num_num = gets
style_num_num = style_num_num.chomp

catalogFPO = CatalogFPO.new
catalogFPO.priority_path = "/Users/brett_piatt/Devel/Product_Images/SPRING_11"
catalogFPO.secondary_path = "/Users/brett_piatt/Devel/Product_Images/FALL_11"

findResult = catalogFPO.get_image(style_num_alpha, style_num_num)

unless findResult then puts "FPO not found for style number: #{style_num_alpha}!" end
