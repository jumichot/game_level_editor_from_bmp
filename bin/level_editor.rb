#!/usr/bin/env ruby

require 'level_editor'
require 'benchmark'

puts ""
puts ""

Benchmark.bm 16 do |x|
  x.report "Durée du traitement :" do
    @level = LevelEditor::Level.new ARGV[0]
    @img = @level.image_interroger
    @objects = @level.objects
  end
end

puts ""

puts "============================================================="
puts "                  APPOLLO MILK LEVEL EDITOR                  "
puts "============================================================="
puts "Longueur du niveau \t #{@img.width}m"
puts "Barres horizontales  \t #{@objects[:horizontal_bars].count}"
puts "Barres verticales  \t #{@objects[:vertical_bars].count}"
puts ""

puts "Output pour unity :"
puts ""

@level.to_unity

