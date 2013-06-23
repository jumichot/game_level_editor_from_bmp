require "minitest_helper"

describe LevelEditor::Editor do

  describe "with small 6x3 image" do
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

    it "can retrieve the horizontal bars count " do
      @editor.objects[:horizontal_bars].count.must_equal(1)
    end

    it "can retrieve the horizontal bars detail " do
      @editor.objects[:horizontal_bars].must_equal([[0,2,1]])
    end
  end

  describe "with another 6x3 image with only vertical bars" do
    #   012345
    # 0 oxoxxx    x white
    # 1 oxo-xo    o black
    # 2 xxoxxo    - red

    def self.editor
      @editor ||= LevelEditor::Editor.new("images/test_case_2.bmp")
    end

    it "has no horizontal bar" do
      self.class.editor.objects[:horizontal_bars].size.must_equal(0)
    end

    it "has 3 vertical bars" do
      self.class.editor.objects[:vertical_bars].size.must_equal(3)
    end

    it "have the details of the vertical bars" do
      self.class.editor.objects[:vertical_bars].must_equal([[0, 0, 1], [2, 0, 2], [5, 1, 2]])
    end
  end

  describe "with bigger 100x51 image" do
    def self.editor
      @editor ||= LevelEditor::Editor.new("images/test_case_horizontale_lines.bmp")
    end

    it "can get the horizontal bars count" do
      self.class.editor.objects[:horizontal_bars].size.must_equal(8)
    end

    it "can have the detail of horizontal_bars" do
      self.class.editor.objects[:horizontal_bars].must_equal([[0, 23, 0], [120, 139, 0], [13, 36, 11], [127, 139, 22], [0, 35, 25], [8, 52, 32], [0, 31, 50], [123, 139, 50]])
    end

    it "can get all the vertical_bars" do
      self.class.editor.objects[:vertical_bars].size.must_equal(11)
    end

    it "can have the detail of vertical bars" do
      self.class.editor.objects[:vertical_bars].must_equal([[0, 0, 16], [67, 0, 50], [139, 0, 13], [36, 3, 11], [83, 19, 35], [127, 22, 34], [35, 25, 29], [51, 26, 32], [0, 34, 50], [2, 36, 45], [139, 37, 50]])
    end
  end

end
