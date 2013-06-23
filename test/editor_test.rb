require "minitest/autorun"
require 'minitest/ansi'

require 'level_editor.rb'

MiniTest::ANSI.use!

describe LevelEditor::Editor do
  describe "with small image 6x3" do

    #   012345
    # 0 xxxoxx    x white
    # 1 ooo-xx    o black
    # 2 xxxxxo    - red

    before do
      @editor = LevelEditor::Editor.new("images/test_case1.bmp")
    end

    it "must have an LevelEditor::Image instance attribute" do
      @editor.image.class.must_equal LevelEditor::Image
    end

    it "can retrieve horizontal bars" do
      @editor.objects["horizontal_bars"].count.must_equal(1)
      @editor.objects["horizontal_bars"].must_equal([[0,2,1]])
    end
  end

  describe "with bigger 100x51 image" do
    before do
      @editor = LevelEditor::Editor.new("images/test_case_horizontale_lines.bmp")
    end

    it "can get all the horizontal bars" do
      @editor.objects["horizontal_bars"].size.must_equal(8)
      @editor.objects["horizontal_bars"].must_equal([[0, 23, 0], [120, 139, 0], [13, 36, 11], [127, 139, 22], [0, 35, 25], [8, 52, 32], [0, 31, 50], [123, 139, 50]])
    end

    it "can get all the vertical_bars" do
      @editor.objects["vertical_bars"].size.must_equal(11)
      @editor.objects["vertical_bars"].must_equal([[0, 0, 16], [67, 0, 50], [139, 0, 13], [36, 3, 11], [83, 19, 35], [127, 22, 34], [35, 25, 29], [51, 26, 32], [0, 34, 50], [2, 36, 45], [139, 37, 50]])
    end
  end

end
