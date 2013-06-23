#!/usr/bin/env ruby

require 'level_editor'
require 'benchmark'

puts ""
puts ""

Benchmark.bm 16 do |x|
  x.report "Durée traitement" do
    @editor = LevelEditor::Editor.new ARGV[0]
    @img = @editor.image_interroger
    @objects = @editor.find_all_objects
  end
end

puts ""

puts "============================================================="
puts "                  APPOLLO MILK LEVEL EDITOR                  "
puts "============================================================="
puts "Longueur du niveau \t #{@img.width}m"
puts "Barres horizontales  \t #{@objects[:horizontal_bars].count}"
puts "Barres verticales  \t #{@objects[:vertical_bars].count}"

